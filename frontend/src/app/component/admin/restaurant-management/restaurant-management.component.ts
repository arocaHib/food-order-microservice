import { Component, OnInit } from '@angular/core';
import { Restaurant } from '../../../dto/Restaurant';
import { RestaurantService } from '../../../service/restaurant.service';
import { Page } from '../../../dto/Page';

@Component({
  selector: 'app-restaurant-management',
  templateUrl: './restaurant-management.component.html',
  styleUrl: './restaurant-management.component.css'
})
export class RestaurantManagementComponent implements OnInit {
  restaurants: Restaurant[] = [];
  currentPage = 0;
  pageSize = 10;
  totalElements = 0;
  totalPages = 0;
  searchKeyword = '';

  showDialog = false;
  selectedRestaurant?: Restaurant;
  isLoading = false;
  errorMessage = '';

  // Expose Math to template
  Math = Math;

  constructor(private restaurantService: RestaurantService) {}

  ngOnInit(): void {
    this.loadRestaurants();
  }

  loadRestaurants(): void {
    this.isLoading = true;
    this.errorMessage = '';

    this.restaurantService.getAllRestaurants(this.currentPage, this.pageSize, this.searchKeyword)
      .subscribe({
        next: (page: Page<Restaurant>) => {
          this.restaurants = page.content;
          this.totalElements = page.totalElements;
          this.totalPages = page.totalPages;
          this.currentPage = page.number;
          this.isLoading = false;
        },
        error: (error) => {
          this.errorMessage = error.message || 'Error loading restaurants';
          this.isLoading = false;
        }
      });
  }

  onSearch(): void {
    this.currentPage = 0;
    this.loadRestaurants();
  }

  onPageChange(page: number): void {
    if (page >= 0 && page < this.totalPages) {
      this.currentPage = page;
      this.loadRestaurants();
    }
  }

  openCreateDialog(): void {
    this.selectedRestaurant = undefined;
    this.showDialog = true;
  }

  openEditDialog(restaurant: Restaurant): void {
    this.selectedRestaurant = { ...restaurant };
    this.showDialog = true;
  }

  closeDialog(): void {
    this.showDialog = false;
    this.selectedRestaurant = undefined;
  }

  onRestaurantSaved(): void {
    this.closeDialog();
    this.loadRestaurants();
  }

  deleteRestaurant(restaurant: Restaurant): void {
    if (confirm(`Are you sure you want to delete "${restaurant.name}"?`)) {
      this.restaurantService.deleteRestaurant(restaurant.restaurantId).subscribe({
        next: () => {
          this.loadRestaurants();
        },
        error: (error) => {
          this.errorMessage = error.message || 'Error deleting restaurant';
        }
      });
    }
  }

  getImageUrl(image?: string): string {
    if (image) {
      return this.restaurantService.getImageUrl(image);
    }
    return 'assets/placeholder-restaurant.jpg';
  }

  get pages(): number[] {
    return Array.from({ length: this.totalPages }, (_, i) => i);
  }
}
