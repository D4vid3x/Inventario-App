import { createRoot } from 'react-dom/client'
import './index.css'
import App from './App.tsx'
import keycloak from './services/keycloak'

keycloak.init({ onLoad: 'login-required', checkLoginIframe: false }).then(authenticated => {
  if (!authenticated) return

  createRoot(document.getElementById('root')!).render(<App />)
})
