<?php

use App\Http\Controllers\Api\EventController;
use App\Http\Controllers\Api\RegistrationController;
use Illuminate\Support\Facades\Route;

// Événements
Route::get('/events', [EventController::class, 'index']);
Route::post('/events', [EventController::class, 'store']);
Route::get('/events/{id}', [EventController::class, 'show']);
Route::delete('/events/{id}', [EventController::class, 'destroy']);

// Inscriptions
Route::get('/events/{id}/registrations', [RegistrationController::class, 'index']);
Route::post('/events/{id}/registrations', [RegistrationController::class, 'store']);
