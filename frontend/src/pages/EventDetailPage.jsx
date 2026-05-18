import { useEffect, useState } from 'react'
import { useParams, useNavigate, Link } from 'react-router-dom'
import { MapPin, Calendar, Users, ArrowLeft, Trash2, Loader2, CheckCircle } from 'lucide-react'
import RegisterModal from '../components/RegisterModal'
import { eventService, registrationService } from '../api/eventService'

function formatDate(iso) {
  return new Date(iso).toLocaleDateString('fr-FR', {
    weekday: 'long', day: 'numeric', month: 'long',
    year: 'numeric', hour: '2-digit', minute: '2-digit',
  })
}

export default function EventDetailPage() {
  const { id }       = useParams()
  const navigate     = useNavigate()
  const [event, setEvent]               = useState(null)
  const [registrations, setRegistrations] = useState([])
  const [loading, setLoading]           = useState(true)
  const [showModal, setShowModal]       = useState(false)
  const [success, setSuccess]           = useState(null)

  useEffect(() => {
    Promise.all([
      eventService.getById(id),
      registrationService.getByEvent(id),
    ]).then(([ev, regs]) => {
      setEvent(ev)
      setRegistrations(regs)
    }).finally(() => setLoading(false))
  }, [id])

  const handleDelete = async () => {
    if (!confirm('Supprimer cet événement ?')) return
    await eventService.delete(id)
    navigate('/')
  }

  const handleSuccess = (reg) => {
    setSuccess(reg)
    setShowModal(false)
    // Mettre à jour le compteur localement
    setEvent(prev => ({ ...prev, registeredCount: prev.registeredCount + 1 }))
    setRegistrations(prev => [reg, ...prev])
  }

  if (loading) {
    return (
      <div className="flex justify-center items-center min-h-[60vh]">
        <Loader2 size={32} className="animate-spin text-brand-500" />
      </div>
    )
  }

  if (!event) {
    return (
      <div className="flex flex-col items-center justify-center min-h-[60vh] text-stone-500">
        <p>Événement introuvable.</p>
        <Link to="/" className="mt-4 text-brand-400 text-sm">← Retour</Link>
      </div>
    )
  }

  const isFull = event.registeredCount >= event.capacity
  const pct    = Math.round((event.registeredCount / event.capacity) * 100)

  return (
    <div className="max-w-3xl mx-auto px-4 py-10">

      {/* Retour */}
      <Link to="/" className="inline-flex items-center gap-2 text-stone-400 hover:text-white text-sm mb-8 transition-colors">
        <ArrowLeft size={16} /> Tous les événements
      </Link>

      {/* Notification succès */}
      {success && (
        <div className="bg-green-900/40 border border-green-700 text-green-300 px-4 py-3 rounded-xl flex items-center gap-3 mb-6 text-sm">
          <CheckCircle size={18} />
          Inscription confirmée pour <strong>{success.firstName} {success.lastName}</strong> !
        </div>
      )}

      {/* Header événement */}
      <div className="bg-stone-900 border border-stone-800 rounded-2xl p-6 mb-6">
        <div className="flex justify-between items-start mb-4">
          <span className={`text-xs font-medium px-2.5 py-1 rounded-full ${
            isFull ? 'bg-red-900/50 text-red-400' : 'bg-brand-900/50 text-brand-400'
          }`}>
            {isFull ? '🔒 Complet' : '✅ Inscriptions ouvertes'}
          </span>
          <button onClick={handleDelete} className="text-stone-600 hover:text-red-400 transition-colors">
            <Trash2 size={18} />
          </button>
        </div>

        <h1 className="font-display text-3xl font-extrabold text-white mb-3">{event.title}</h1>

        {event.description && (
          <p className="text-stone-400 mb-5 leading-relaxed">{event.description}</p>
        )}

        {/* Métadonnées */}
        <div className="space-y-2 text-sm text-stone-400 mb-5">
          <div className="flex items-center gap-2">
            <Calendar size={15} className="text-brand-500" />
            <span className="capitalize">{formatDate(event.date)}</span>
          </div>
          <div className="flex items-center gap-2">
            <MapPin size={15} className="text-brand-500" />
            <span>{event.location}</span>
          </div>
          <div className="flex items-center gap-2">
            <Users size={15} className="text-brand-500" />
            <span>{event.registeredCount} / {event.capacity} inscrits</span>
          </div>
        </div>

        {/* Barre de capacité */}
        <div className="mb-5">
          <div className="h-2 bg-stone-800 rounded-full overflow-hidden">
            <div
              className={`h-full rounded-full transition-all duration-700 ${isFull ? 'bg-red-500' : 'bg-brand-500'}`}
              style={{ width: `${pct}%` }}
            />
          </div>
          <p className="text-xs text-stone-500 mt-1">{pct}% des places prises</p>
        </div>

        {/* Bouton inscription */}
        <button
          onClick={() => setShowModal(true)}
          disabled={isFull}
          className="w-full bg-brand-500 hover:bg-brand-600 disabled:opacity-50 disabled:cursor-not-allowed text-white font-medium py-3 rounded-xl transition-colors"
        >
          {isFull ? 'Événement complet' : "S'inscrire à cet événement"}
        </button>
      </div>

      {/* Liste des inscrits */}
      {registrations.length > 0 && (
        <div className="bg-stone-900 border border-stone-800 rounded-2xl p-6">
          <h2 className="font-display text-lg font-bold text-white mb-4 flex items-center gap-2">
            <Users size={18} className="text-brand-500" />
            Participants ({registrations.length})
          </h2>
          <div className="space-y-2">
            {registrations.map(r => (
              <div key={r.id} className="flex items-center justify-between py-2.5 border-b border-stone-800 last:border-0">
                <div>
                  <p className="text-sm font-medium text-white">{r.firstName} {r.lastName}</p>
                  <p className="text-xs text-stone-500">{r.email}</p>
                </div>
                <span className="text-xs text-stone-600">
                  {new Date(r.registeredAt).toLocaleDateString('fr-FR')}
                </span>
              </div>
            ))}
          </div>
        </div>
      )}

      {/* Modal */}
      {showModal && (
        <RegisterModal
          event={event}
          onClose={() => setShowModal(false)}
          onSuccess={handleSuccess}
        />
      )}
    </div>
  )
}
