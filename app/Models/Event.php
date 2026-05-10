<?php

namespace App\Models;

use Illuminate\Database\Eloquent\Model;

class Event extends Model
{
    protected $fillable = [
        'title',
        'description',
        'date',
        'location',
        'capacity',
    ];

    protected $hidden = ['updated_at'];

    // Formater la sortie JSON (snake_case → camelCase)
    protected function serializeDate(\DateTimeInterface $date): string
    {
        return $date->format('Y-m-d\TH:i:s\Z');
    }

    public function registrations()
    {
        return $this->hasMany(Registration::class);
    }

    // Nombre d'inscrits
    public function registrationsCount(): int
    {
        return $this->registrations()->count();
    }

    // Vérifie si l'événement est complet
    public function isFull(): bool
    {
        return $this->registrationsCount() >= $this->capacity;
    }
}
