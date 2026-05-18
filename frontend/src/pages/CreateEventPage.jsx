import { useState } from 'react'
import { useNavigate, Link } from 'react-router-dom'
import { ArrowLeft, Loader2 } from 'lucide-react'
import { eventService } from '../api/eventService'

export default function CreateEventPage() {
  const navigate = useNavigate()
  const [form, setForm]     = useState({
    title: '', description: '', date: '', location: '', capacity: '',
  })
  const [loading, setLoading] = useState(false)
  const [error, setError]   = useState(null)

  const handleChange = e => setForm(prev => ({ ...prev, [e.target.name]: e.target.value }))

  const handleSubmit = async (e) => {
    e.preventDefault()
    setLoading(true)
    setError(null)

    try {
      // Convertir la date locale en ISO 8601 UTC
      const isoDate = new Date(form.date).toISOString().replace(/\.\d{3}Z$/, 'Z')
      const event = await eventService.create({
        ...form,
        date: isoDate,
        capacity: parseInt(form.capacity),
      })
      navigate(`/events/${event.id}`)
    } catch (err) {
      setError(err.response?.data?.message || 'Erreur lors de la création.')
    } finally {
      setLoading(false)
    }
  }

  const inputClass = "w-full bg-stone-900 border border-stone-800 rounded-xl px-4 py-3 text-sm text-white focus:outline-none focus:border-brand-500 transition-colors placeholder:text-stone-600"
  const labelClass = "block text-xs font-medium text-stone-400 mb-1.5"

  return (
    <div className="max-w-xl mx-auto px-4 py-10">
      <Link to="/" className="inline-flex items-center gap-2 text-stone-400 hover:text-white text-sm mb-8 transition-colors">
        <ArrowLeft size={16} /> Retour
      </Link>

      <h1 className="font-display text-3xl font-extrabold text-white mb-8">
        Créer un événement
      </h1>

      {error && (
        <div className="bg-red-900/40 border border-red-700 text-red-300 text-sm px-4 py-3 rounded-xl mb-6">
          {error}
        </div>
      )}

      <form onSubmit={handleSubmit} className="space-y-5">
        <div>
          <label className={labelClass}>Titre *</label>
          <input type="text" name="title" value={form.title}
            onChange={handleChange} required maxLength={100}
            className={inputClass} placeholder="Ex: Conférence Tech BF 2025"
          />
        </div>

        <div>
          <label className={labelClass}>Description</label>
          <textarea name="description" value={form.description}
            onChange={handleChange} rows={3}
            className={`${inputClass} resize-none`}
            placeholder="Description de l'événement (optionnel)"
          />
        </div>

        <div>
          <label className={labelClass}>Date et heure *</label>
          <input type="datetime-local" name="date" value={form.date}
            onChange={handleChange} required
            className={inputClass}
          />
        </div>

        <div>
          <label className={labelClass}>Lieu *</label>
          <input type="text" name="location" value={form.location}
            onChange={handleChange} required
            className={inputClass} placeholder="Ex: Ouagadougou, Burkina Faso"
          />
        </div>

        <div>
          <label className={labelClass}>Capacité *</label>
          <input type="number" name="capacity" value={form.capacity}
            onChange={handleChange} required min={1}
            className={inputClass} placeholder="Ex: 100"
          />
        </div>

        <button type="submit" disabled={loading}
          className="w-full bg-brand-500 hover:bg-brand-600 disabled:opacity-60 text-white font-medium py-3 rounded-xl transition-colors flex items-center justify-center gap-2 mt-2"
        >
          {loading && <Loader2 size={16} className="animate-spin" />}
          {loading ? 'Création...' : "Créer l'événement"}
        </button>
      </form>
    </div>
  )
}
