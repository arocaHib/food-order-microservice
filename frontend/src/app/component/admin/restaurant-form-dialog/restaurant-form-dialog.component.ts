import { Component, EventEmitter, Input, Output, OnInit } from '@angular/core';
import { FormBuilder, FormGroup, Validators } from '@angular/forms';
import { Restaurant } from '../../../dto/Restaurant';
import { RestaurantService } from '../../../service/restaurant.service';

@Component({
  selector: 'app-restaurant-form-dialog',
  templateUrl: './restaurant-form-dialog.component.html',
  styleUrl: './restaurant-form-dialog.component.css'
})
export class RestaurantFormDialogComponent implements OnInit {
  @Input() restaurant?: Restaurant;
  @Output() close = new EventEmitter<void>();
  @Output() restaurantSaved = new EventEmitter<void>();

  form!: FormGroup;
  isEditMode!: boolean;
  errorMessage = '';
  isLoading = false;
  selectedFile: File | null = null;
  imagePreview: string | null = null;

  constructor(
    private fb: FormBuilder,
    private restaurantService: RestaurantService
  ) {
    this.initForm();
  }

  ngOnInit(): void {
    this.isEditMode = !!this.restaurant?.restaurantId;
    this.initForm();

    if (this.restaurant?.image) {
      this.imagePreview = this.restaurant.image;
    }
  }

  private initForm(): void {
    this.form = this.fb.group({
      restaurantId: [this.restaurant?.restaurantId],
      name: [this.restaurant?.name, [Validators.required, Validators.minLength(3)]],
      address: [this.restaurant?.address, [Validators.required]],
      image: [this.restaurant?.image]
    });
  }

  onFileSelected(event: any): void {
    const file = event.target.files[0];
    if (file) {
      this.selectedFile = file;

      // Preview image
      const reader = new FileReader();
      reader.onload = (e: any) => {
        this.imagePreview = e.target.result;
      };
      reader.readAsDataURL(file);
    }
  }

  onSubmit(): void {
    if (this.form.valid) {
      this.isLoading = true;
      const restaurantData = { ...this.form.value };

      const operation = this.isEditMode ?
        this.restaurantService.updateRestaurant(restaurantData.restaurantId, restaurantData) :
        this.restaurantService.createRestaurant(restaurantData);

      operation.subscribe({
        next: (savedRestaurant) => {
          // If there's a file to upload, upload it
          if (this.selectedFile && savedRestaurant.restaurantId) {
            this.uploadImage(savedRestaurant.restaurantId);
          } else {
            this.restaurantSaved.emit();
          }
        },
        error: (error) => {
          this.errorMessage = error.message || 'Error saving restaurant';
          this.isLoading = false;
        }
      });
    }
  }

  private uploadImage(restaurantId: number): void {
    if (this.selectedFile) {
      this.restaurantService.uploadRestaurantImage(restaurantId, this.selectedFile).subscribe({
        next: () => {
          this.restaurantSaved.emit();
        },
        error: (error) => {
          this.errorMessage = 'Restaurant saved but error uploading image: ' + error.message;
          this.isLoading = false;
        }
      });
    }
  }
}
