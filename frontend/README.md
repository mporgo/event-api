# EventHub — Frontend React (Vite)

Interface utilisateur de l'application de gestion d'événements.  
Construite avec **React + Vite**, **Tailwind CSS** et **React Router DOM**.

---

## Prérequis

- Node.js >= 18.x
- npm >= 9.x
- Le **backend Laravel** lancé sur `http://localhost:8000`

> Vérifie ta version Node : `node -v`

---

## Installation

### 1. Se placer dans le dossier frontend

```bash
cd frontend
```

### 2. Installer les dépendances

```bash
npm install
```

### 3. Lancer le serveur de développement

```bash
npm run dev
```

L'application est accessible sur : **http://localhost:5173**

> Le proxy Vite redirige automatiquement les requêtes `/api/*` vers `http://localhost:8000`.  

---

## Structure du projet

```
frontend/
├── public/
├── src/
│   ├── api/
│   │   └── eventService.js       # Couche service — appels API via axios
│   ├── components/
│   │   ├── Navbar.jsx             # Barre de navigation
│   │   ├── EventCard.jsx          # Carte événement (liste)
│   │   └── RegisterModal.jsx      # Modal d'inscription
│   ├── pages/
│   │   ├── EventListPage.jsx      # Page d'accueil — liste des événements
│   │   ├── EventDetailPage.jsx    # Page détail + inscrits
│   │   └── CreateEventPage.jsx    # Formulaire de création
│   ├── App.jsx                    # Routeur principal
│   ├── main.jsx                   # Point d'entrée React
│   └── index.css                  # Styles globaux + Tailwind
├── vite.config.js                 # Config Vite + proxy API
├── tailwind.config.js             # Config Tailwind
└── package.json
```

---

## Pages disponibles

| Route | Page | Description |
|---|---|---|
| `/` | EventListPage | Liste de tous les événements avec recherche |
| `/events/new` | CreateEventPage | Formulaire de création d'événement |
| `/events/:id` | EventDetailPage | Détail, inscrits et formulaire d'inscription |

---

## Communication avec l'API

Toutes les requêtes HTTP passent par `src/api/eventService.js`.

```js
// Exemples d'utilisation dans un composant
import { eventService, registrationService } from '../api/eventService'

// Récupérer tous les événements
const events = await eventService.getAll()

// Créer un événement
const event = await eventService.create({ title, date, location, capacity })

// S'inscrire à un événement
const reg = await registrationService.register(eventId, { firstName, lastName, email })
```

Le proxy Vite est configuré dans `vite.config.js` :

```js
proxy: {
  '/api': {
    target: 'http://localhost:8000',
    changeOrigin: true,
  }
}
```

---

## Dépendances principales

| Package | Version | Usage |
|---|---|---|
| `react` | ^18 | Framework UI |
| `react-dom` | ^18 | Rendu DOM |
| `react-router-dom` | ^6 | Routing SPA |
| `axios` | ^1 | Requêtes HTTP |
| `lucide-react` | latest | Icônes |
| `tailwindcss` | ^3 | Styles utilitaires |
| `vite` | ^5 | Build tool |
| `@vitejs/plugin-react` | ^4 | Support JSX/React |

---

## Scripts disponibles

```bash
npm run dev      # Lance le serveur de développement (hot reload)
npm run build    # Build de production dans /dist
npm run preview  # Prévisualise le build de production
```

---

## Build de production

```bash
npm run build
```

## Lancer le projet complet

```bash
# Terminal 1 — Backend Laravel
cd event-api
php artisan serve

# Terminal 2 — Frontend React
cd event-api/frontend
npm run dev
```

| Service | URL |
|---|---|
| API Laravel | http://localhost:8000/api |
| Frontend React | http://localhost:5173 |

---
