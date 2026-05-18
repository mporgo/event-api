import { useState } from 'react'
import { X, Loader2 } from 'lucide-react'
import { registrationService } from '../api/eventService'

export default function RegisterModal({ event, onClose, onSuccess }) {
  const [form, setForm]     = useState({ firstName: '', lastName: '', email: '' })
  const [loading, setLoading] = useState(false)
  const [error, setError]   = useState(null)

  const handleChange = e => setForm(prev => ({ ...prev, [e.target.name]: e.target.value }))

  const handleSubmit = async (e) => {
    e.preventDefault()
    setLoading(true)
    setError(null)

    try {
      const result = await registrationService.register(event.id, form)
      onSuccess(result)
    } catch (err) {
      const msg = err.response?.data?.message || 'Une erreur est survenue.'
      setError(msg)
    } finally {
      setLoading(false)
    }
  }

  return (
    <div className="fixed inset-0 z-50 flex items-center justify-center bg-black/70 backdrop-blur-sm px-4">
      <div className="bg-stone-900 border border-stone-700 rounded-2xl w-full max-w-md p-6 relative">

        {/* Header */}
        <button onClick={onClose} className="absolute top-4 right-4 text-stone-500 hover:text-white transition-colors">
          <X size={20} />
        </button>
        <h2 className="font-display text-xl font-bold text-white mb-1">S'inscrire</h2>
        <p className="text-stone-400 text-sm mb-6 truncate">{event.title}</p>

        {/* Erreur */}
        {error && (
          <div className="bg-red-900/40 border border-red-700 text-red-300 text-sm px-4 py-3 rounded-lg mb-4">
            {error}
          </div>
        )}

        {/* Formulaire */}
        <form onSubmit={handleSubmit} className="space-y-4">
          <div className="grid grid-cols-2 gap-3">
            <div>
              <label className="text-xs text-stone-400 block mb-1">Prénom *</label>
              <input
                type="text"
                name="firstName"
                value={form.firstName}
                onChange={handleChange}
                required
                className="w-full bg-stone-800 border border-stone-700 rounded-lg px-3 py-2.5 text-sm text-white focus:outline-none focus:border-brand-500 transition-colors"
                placeholder="Aminata"
              />
            </div>
            <div>
              <label className="text-xs text-stone-400 block mb-1">Nom *</label>
              <input
                type="text"
                name="lastName"
                value={form.lastName}
                onChange={handleChange}
                required
                className="w-full bg-stone-800 border border-stone-700 rounded-lg px-3 py-2.5 text-sm text-white focus:outline-none focus:border-brand-500 transition-colors"
                placeholder="Ouedraogo"
              />
            </div>
          </div>

          <div>
            <label className="text-xs text-stone-400 block mb-1">Email *</label>
            <input
              type="email"
              name="email"
              value={form.email}
              onChange={handleChange}
              required
              className="w-full bg-stone-800 border border-stone-700 rounded-lg px-3 py-2.5 text-sm text-white focus:outline-none focus:border-brand-500 transition-colors"
              placeholder="aminata@example.com"
            />
          </div>

          <button
            type="submit"
            disabled={loading}
            className="w-full bg-brand-500 hover:bg-brand-600 disabled:opacity-60 text-white font-medium py-2.5 rounded-lg transition-colors flex items-center justify-center gap-2 mt-2"
          >
            {loading && <Loader2 size={16} className="animate-spin" />}
            {loading ? 'Inscription...' : "Confirmer l'inscription"}
          </button>
        </form>
      </div>
    </div>
  )
}
