import axios from 'axios'

const api = axios.create({
  baseURL: '/api',
  headers: { 'Content-Type': 'application/json' },
})

export const eventService = {
  // Récupérer tous les événements
  getAll: () => api.get('/events').then(r => r.data),

  // Récupérer un événement par ID
  getById: (id) => api.get(`/events/${id}`).then(r => r.data),

  // Créer un événement
  create: (data) => api.post('/events', data).then(r => r.data),

  // Supprimer un événement
  delete: (id) => api.delete(`/events/${id}`).then(r => r.data),
}

export const registrationService = {
  // S'inscrire à un événement
  register: (eventId, data) =>
    api.post(`/events/${eventId}/registrations`, data).then(r => r.data),

  // Lister les inscrits
  getByEvent: (eventId) =>
    api.get(`/events/${eventId}/registrations`).then(r => r.data),
}
