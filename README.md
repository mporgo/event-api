# 📅 Event API — Laravel REST API

Application de gestion d'événements avec inscriptions en ligne.

---

## 🛠️ Prérequis

- PHP >= 8.1
- Composer
- MySQL >= 5.7
- Laravel >= 12.x

---

## 🚀 Installation

### 1. Cloner le projet

```bash
git clone https://github.com/ton-user/event-api.git
cd event-api
```

### 2. Installer les dépendances

```bash
composer install
```

### 3. Configurer l'environnement

```bash
cp .env.example .env
php artisan key:generate
```

Édite `.env` avec tes infos MySQL :

```env
DB_CONNECTION=mysql
DB_HOST=127.0.0.1
DB_PORT=3306
DB_DATABASE=event_db
DB_USERNAME=root
DB_PASSWORD=ton_mot_de_passe
```

### 4. Créer la base de données
J'utilise Ubuntu :
```bash
mysql -u root -p -e "CREATE DATABASE event_db CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci;"
```

### 5. Lancer les migrations

```bash
php artisan migrate
```

### 6. (Laravel 12) Activer les routes API

```bash
php artisan install:api
```

### 7. Lancer le serveur

```bash
php artisan serve
```

L'API est accessible sur : `http://localhost:8000/api`

---

## 📡 Endpoints

### Événements

| Méthode | Endpoint           | Description              |
|---------|--------------------|--------------------------|
| GET     | /api/events        | Liste des événements     |
| POST    | /api/events        | Créer un événement       |
| GET     | /api/events/{id}   | Détails d'un événement   |
| DELETE  | /api/events/{id}   | Supprimer un événement   |

### Inscriptions

| Méthode | Endpoint                          | Description                    |
|---------|-----------------------------------|--------------------------------|
| POST    | /api/events/{id}/registrations    | S'inscrire à un événement      |
| GET     | /api/events/{id}/registrations    | Liste des inscrits             |

---

## 📋 Exemples de requêtes

### Créer un événement

```bash
curl -X POST http://localhost:8000/api/events \
  -H "Content-Type: application/json" \
  -d '{
    "title": "Conférence Tech BF 2025",
    "description": "Événement annuel des développeurs du Burkina",
    "date": "2025-11-15T18:00:00Z",
    "location": "Ouagadougou, Burkina Faso",
    "capacity": 100
  }'
```

**Réponse — HTTP 201 :**
```json
{
  "id": 1,
  "title": "Conférence Tech BF 2025",
  "description": "Événement annuel des développeurs du Burkina",
  "date": "2025-11-15T18:00:00Z",
  "location": "Ouagadougou, Burkina Faso",
  "capacity": 100,
  "createdAt": "2025-11-12T09:00:00Z"
}
```

---

### S'inscrire à un événement

```bash
curl -X POST http://localhost:8000/api/events/1/registrations \
  -H "Content-Type: application/json" \
  -d '{
    "firstName": "Aminata",
    "lastName": "Ouedraogo",
    "email": "aminata@example.com"
  }'
```

**Réponse — HTTP 201 :**
```json
{
  "id": 1,
  "eventId": 1,
  "firstName": "Aminata",
  "lastName": "Ouedraogo",
  "email": "aminata@example.com",
  "registeredAt": "2025-11-12T09:00:00Z"
}
```

---

### Erreurs possibles

**Événement complet — HTTP 422 :**
```json
{
  "error": "CAPACITY_REACHED",
  "message": "Cet evenement est complet."
}
```

**Email déjà inscrit — HTTP 409 :**
```json
{
  "error": "DUPLICATE_EMAIL",
  "message": "Cette adresse email est deja enregistree pour cet evenement."
}
```

**Événement introuvable — HTTP 404 :**
```json
{
  "error": "NOT_FOUND",
  "message": "Événement introuvable."
}
```

---

## 🧪 Tester avec Postman

1. Importe la collection Postman (si fournie)
2. Ou crée les requêtes manuellement avec les endpoints ci-dessus
3. Base URL : `http://localhost:8000/api`
4. Header obligatoire : `Content-Type: application/json`

---

## 📁 Structure du projet

```
event-api/
├── app/
│   ├── Http/Controllers/Api/
│   │   ├── EventController.php
│   │   └── RegistrationController.php
│   └── Models/
│       ├── Event.php
│       └── Registration.php
├── database/migrations/
│   ├── xxxx_create_events_table.php
│   └── xxxx_create_registrations_table.php
├── routes/
│   └── api.php
├── .env.example
└── README.md
```

---

## 👨‍💻 Auteur

**PORGO** — ESI / Université Nazi Boni  
Licence 3 — Ingénierie des Systèmes d'Information
