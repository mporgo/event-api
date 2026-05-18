import { Link } from 'react-router-dom'
import { CalendarDays } from 'lucide-react'

export default function Navbar() {
  return (
    <nav className="border-b border-stone-800 px-6 py-4 flex items-center justify-between sticky top-0 bg-[#0c0a09]/90 backdrop-blur z-50">
      <Link to="/" className="flex items-center gap-2 font-display text-xl font-bold text-brand-400">
        <CalendarDays size={22} />
        EventHub
      </Link>
      <Link
        to="/events/new"
        className="bg-brand-500 hover:bg-brand-600 text-white text-sm font-medium px-4 py-2 rounded-lg transition-colors"
      >
        + Nouvel événement
      </Link>
    </nav>
  )
}
