<?php

namespace App\Models;

use Illuminate\Database\Eloquent\Model;

class Registration extends Model
{
    protected $fillable = [
        'event_id',
        'first_name',
        'last_name',
        'email',
        'registered_at',
    ];

    protected $hidden = ['updated_at', 'created_at'];

    protected function serializeDate(\DateTimeInterface $date): string
    {
        return $date->format('Y-m-d\TH:i:s\Z');
    }

    public function event()
    {
        return $this->belongsTo(Event::class);
    }

    // Formater en camelCase pour la réponse JSON
    public function toArray(): array
    {
        return [
            'id'           => $this->id,
            'eventId'      => $this->event_id,
            'firstName'    => $this->first_name,
            'lastName'     => $this->last_name,
            'email'        => $this->email,
            'registeredAt' => $this->registered_at,
        ];
    }
}
