import { Link } from 'react-router-dom'
import { MapPin, Users, Calendar } from 'lucide-react'

function formatDate(iso) {
  return new Date(iso).toLocaleDateString('fr-FR', {
    day: 'numeric', month: 'long', year: 'numeric',
    hour: '2-digit', minute: '2-digit',
  })
}

export default function EventCard({ event }) {
  const isFull = event.registeredCount >= event.capacity
  const pct    = Math.round((event.registeredCount / event.capacity) * 100)

  return (
    <Link
      to={`/events/${event.id}`}
      className="block bg-stone-900 border border-stone-800 rounded-2xl p-5 hover:border-brand-500 transition-all duration-200 hover:-translate-y-1 group"
    >
      {/* Badge statut */}
      <div className="flex justify-between items-start mb-3">
        <span className={`text-xs font-medium px-2.5 py-1 rounded-full ${
          isFull
            ? 'bg-red-900/50 text-red-400'
            : 'bg-brand-900/50 text-brand-400'
        }`}>
          {isFull ? 'Complet' : 'Places disponibles'}
        </span>
        <span className="text-xs text-stone-500">{event.registeredCount}/{event.capacity}</span>
      </div>

      {/* Titre */}
      <h3 className="font-display text-lg font-bold text-white group-hover:text-brand-400 transition-colors mb-2 line-clamp-2">
        {event.title}
      </h3>

      {/* Description */}
      {event.description && (
        <p className="text-stone-400 text-sm line-clamp-2 mb-4">{event.description}</p>
      )}

      {/* Infos */}
      <div className="space-y-1.5 text-sm text-stone-400">
        <div className="flex items-center gap-2">
          <Calendar size={14} className="text-brand-500 shrink-0" />
          <span>{formatDate(event.date)}</span>
        </div>
        <div className="flex items-center gap-2">
          <MapPin size={14} className="text-brand-500 shrink-0" />
          <span className="truncate">{event.location}</span>
        </div>
      </div>

      {/* Barre de progression capacité */}
      <div className="mt-4">
        <div className="h-1 bg-stone-800 rounded-full overflow-hidden">
          <div
            className={`h-full rounded-full transition-all duration-500 ${
              isFull ? 'bg-red-500' : 'bg-brand-500'
            }`}
            style={{ width: `${pct}%` }}
          />
        </div>
      </div>
    </Link>
  )
}
