import { inject } from '@angular/core';
import { CanActivateFn, Router, UrlTree } from '@angular/router';
import { AuthService } from '../service/auth.service';

export const AuthGuard: CanActivateFn = (route, state): boolean | UrlTree=> {
  const router = inject(Router);
  const authService = inject(AuthService);

  const requiredRoles = route.data['roles'] as Array<string>;
  if(!authService.isLoggedIn()) {
    // Store the attempted URL for redirecting
  return router.createUrlTree(['/login'], { queryParams: { returnUrl: state.url } });
  }

  if(requiredRoles) {
    const userRoles = authService.getRolesFromToken();
    // Check if user has at least one of the required roles
    const hasRequiredRole = requiredRoles.some(role => userRoles.includes(role));
    if(!hasRequiredRole) {
      return router.createUrlTree(['/unauthorized']);
    }
  }

  return true;

};
