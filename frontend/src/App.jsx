import { BrowserRouter, Routes, Route } from 'react-router-dom'
import Navbar from './components/Navbar'
import EventListPage   from './pages/EventListPage'
import EventDetailPage from './pages/EventDetailPage'
import CreateEventPage from './pages/CreateEventPage'

export default function App() {
  return (
    <BrowserRouter>
      <div className="min-h-screen bg-[#0c0a09]">
        <Navbar />
        <main>
          <Routes>
            <Route path="/"             element={<EventListPage />} />
            <Route path="/events/new"   element={<CreateEventPage />} />
            <Route path="/events/:id"   element={<EventDetailPage />} />
          </Routes>
        </main>
      </div>
    </BrowserRouter>
  )
}
