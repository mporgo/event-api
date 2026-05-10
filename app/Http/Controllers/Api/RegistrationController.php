<?php

namespace App\Http\Controllers\Api;

use App\Http\Controllers\Controller;
use App\Models\Event;
use App\Models\Registration;
use Illuminate\Http\JsonResponse;
use Illuminate\Http\Request;
use Illuminate\Support\Facades\Validator;

class RegistrationController extends Controller
{
    // POST /api/events/{id}/registrations
    public function store(Request $request, int $eventId): JsonResponse
    {
        // 1. Vérifier que l'événement existe
        $event = Event::find($eventId);
        if (!$event) {
            return response()->json([
                'error'   => 'NOT_FOUND',
                'message' => 'Événement introuvable.',
            ], 404);
        }

        // 2. Valider les données
        $validator = Validator::make($request->all(), [
            'firstName' => 'required|string|max:100',
            'lastName'  => 'required|string|max:100',
            'email'     => 'required|email',
        ]);

        if ($validator->fails()) {
            return response()->json([
                'error'   => 'VALIDATION_ERROR',
                'message' => $validator->errors()->first(),
            ], 422);
        }

        // 3. Vérifier la capacité
        if ($event->isFull()) {
            return response()->json([
                'error'   => 'CAPACITY_REACHED',
                'message' => 'Cet evenement est complet.',
            ], 422);
        }

        // 4. Vérifier doublon email pour cet événement
        $alreadyRegistered = Registration::where('event_id', $eventId)
            ->where('email', $request->email)
            ->exists();

        if ($alreadyRegistered) {
            return response()->json([
                'error'   => 'DUPLICATE_EMAIL',
                'message' => 'Cette adresse email est deja enregistree pour cet evenement.',
            ], 409);
        }

        // 5. Créer l'inscription
        $registration = Registration::create([
            'event_id'      => $eventId,
            'first_name'    => $request->firstName,
            'last_name'     => $request->lastName,
            'email'         => $request->email,
            'registered_at' => now()->format('Y-m-d\TH:i:s\Z'),
        ]);

        return response()->json([
            'id'           => $registration->id,
            'eventId'      => $registration->event_id,
            'firstName'    => $registration->first_name,
            'lastName'     => $registration->last_name,
            'email'        => $registration->email,
            'registeredAt' => $registration->registered_at,
        ], 201);
    }

    // GET /api/events/{id}/registrations
    public function index(int $eventId): JsonResponse
    {
        $event = Event::find($eventId);
        if (!$event) {
            return response()->json([
                'error'   => 'NOT_FOUND',
                'message' => 'Événement introuvable.',
            ], 404);
        }

        $registrations = Registration::where('event_id', $eventId)->get()->map(fn($r) => [
            'id'           => $r->id,
            'eventId'      => $r->event_id,
            'firstName'    => $r->first_name,
            'lastName'     => $r->last_name,
            'email'        => $r->email,
            'registeredAt' => $r->registered_at,
        ]);

        return response()->json($registrations, 200);
    }
}
