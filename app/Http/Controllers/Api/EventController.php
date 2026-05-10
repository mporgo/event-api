<?php

namespace App\Http\Controllers\Api;

use App\Http\Controllers\Controller;
use App\Models\Event;
use Illuminate\Http\JsonResponse;
use Illuminate\Http\Request;
use Illuminate\Support\Facades\Validator;

class EventController extends Controller
{
    // GET /api/events
    public function index(): JsonResponse
    {
        $events = Event::withCount('registrations')->get()->map(function ($event) {
            return [
                'id'               => $event->id,
                'title'            => $event->title,
                'description'      => $event->description,
                'date'             => $event->date,
                'location'         => $event->location,
                'capacity'         => $event->capacity,
                'registeredCount'  => $event->registrations_count,
                'createdAt'        => $event->created_at->format('Y-m-d\TH:i:s\Z'),
            ];
        });

        return response()->json($events, 200);
    }

    // POST /api/events
    public function store(Request $request): JsonResponse
    {
        $validator = Validator::make($request->all(), [
            'title'       => 'required|string|max:100',
            'description' => 'nullable|string',
            'date'        => ['required', 'string', 'regex:/^\d{4}-\d{2}-\d{2}T\d{2}:\d{2}:\d{2}Z$/'],
            'location'    => 'required|string',
            'capacity'    => 'required|integer|min:1',
        ]);

        if ($validator->fails()) {
            return response()->json([
                'error'   => 'VALIDATION_ERROR',
                'message' => $validator->errors()->first(),
            ], 422);
        }

        $event = Event::create($validator->validated());

        return response()->json([
            'id'          => $event->id,
            'title'       => $event->title,
            'description' => $event->description,
            'date'        => $event->date,
            'location'    => $event->location,
            'capacity'    => $event->capacity,
            'createdAt'   => $event->created_at->format('Y-m-d\TH:i:s\Z'),
        ], 201);
    }

    // GET /api/events/{id}
    public function show(int $id): JsonResponse
    {
        $event = Event::withCount('registrations')->find($id);

        if (!$event) {
            return response()->json([
                'error'   => 'NOT_FOUND',
                'message' => 'Événement introuvable.',
            ], 404);
        }

        return response()->json([
            'id'              => $event->id,
            'title'           => $event->title,
            'description'     => $event->description,
            'date'            => $event->date,
            'location'        => $event->location,
            'capacity'        => $event->capacity,
            'registeredCount' => $event->registrations_count,
            'createdAt'       => $event->created_at->format('Y-m-d\TH:i:s\Z'),
        ], 200);
    }

    // DELETE /api/events/{id}
    public function destroy(int $id): JsonResponse
    {
        $event = Event::find($id);

        if (!$event) {
            return response()->json([
                'error'   => 'NOT_FOUND',
                'message' => 'Événement introuvable.',
            ], 404);
        }

        $event->delete();

        return response()->json(['message' => 'Événement supprimé.'], 200);
    }
}
