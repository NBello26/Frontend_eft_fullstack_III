import { defineStore } from 'pinia';
import axios from 'axios';
import api from '../api/axiosConfig'; // Importa tu instancia

export const useAuthStore = defineStore('auth', {
  state: () => ({
    usuario: JSON.parse(localStorage.getItem('usuario')) || null,
    token: localStorage.getItem('token') || null,
    sessionId: localStorage.getItem('sessionId') || null,
  }),

  getters: {
    estaAutenticado: (state) => !!state.token,
  },

  actions: {
    async login(credenciales) {
      try {
        const response = await api.post('/auth/login', credenciales);
        
        const { token, usuario, sessionId } = response.data;

        // Guardamos en el estado
        this.token = token;
        this.usuario = usuario;
        this.sessionId = sessionId;

        // Guardamos en localStorage para que no se pierda al recargar
        localStorage.setItem('token', token);
        localStorage.setItem('usuario', JSON.stringify(usuario));
        localStorage.setItem('sessionId', sessionId);

        // Configuramos Axios para futuras peticiones
        axios.defaults.headers.common['Authorization'] = `Bearer ${token}`;
        axios.defaults.headers.common['X-Session-ID'] = sessionId;

        return true;
      } catch (error) {
        console.error("Error en login:", error);
        throw error;
      }
    },

    logout() {
      this.token = null;
      this.usuario = null;
      this.sessionId = null;
      localStorage.removeItem('token');
      localStorage.removeItem('usuario');
      localStorage.removeItem('sessionId');
      delete axios.defaults.headers.common['Authorization'];
      delete axios.defaults.headers.common['X-Session-ID'];
    }
  }
});