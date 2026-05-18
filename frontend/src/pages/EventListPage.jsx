import { useEffect, useState } from 'react'
import { Search, Loader2, CalendarOff } from 'lucide-react'
import EventCard from '../components/EventCard'
import { eventService } from '../api/eventService'

export default function EventListPage() {
  const [events, setEvents]   = useState([])
  const [loading, setLoading] = useState(true)
  const [search, setSearch]   = useState('')

  useEffect(() => {
    eventService.getAll()
      .then(setEvents)
      .finally(() => setLoading(false))
  }, [])

  const filtered = events.filter(e =>
    e.title.toLowerCase().includes(search.toLowerCase()) ||
    e.location.toLowerCase().includes(search.toLowerCase())
  )

  return (
    <div className="max-w-5xl mx-auto px-4 py-10">

      {/* Hero */}
      <div className="mb-10">
        <h1 className="font-display text-4xl font-extrabold text-white mb-2">
          Événements à venir
        </h1>
        <p className="text-stone-400">Découvrez et inscrivez-vous aux prochains événements.</p>
      </div>

      {/* Barre de recherche */}
      <div className="relative mb-8">
        <Search size={16} className="absolute left-4 top-1/2 -translate-y-1/2 text-stone-500" />
        <input
          type="text"
          placeholder="Rechercher par titre ou lieu..."
          value={search}
          onChange={e => setSearch(e.target.value)}
          className="w-full bg-stone-900 border border-stone-800 rounded-xl pl-10 pr-4 py-3 text-sm text-white focus:outline-none focus:border-brand-500 transition-colors"
        />
      </div>

      {/* Contenu */}
      {loading ? (
        <div className="flex justify-center items-center py-24">
          <Loader2 size={32} className="animate-spin text-brand-500" />
        </div>
      ) : filtered.length === 0 ? (
        <div className="flex flex-col items-center justify-center py-24 text-stone-500">
          <CalendarOff size={48} className="mb-4 opacity-40" />
          <p className="text-sm">Aucun événement trouvé.</p>
        </div>
      ) : (
        <div className="grid grid-cols-1 sm:grid-cols-2 lg:grid-cols-3 gap-5">
          {filtered.map(event => (
            <EventCard key={event.id} event={event} />
          ))}
        </div>
      )}
    </div>
  )
}
