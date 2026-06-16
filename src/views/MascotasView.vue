<template>
  <div class="dashboard-container">
    <div class="header-section">
      <h2>Mascotas Reportadas</h2>
      <p>Ayúdanos a reunirlos con sus familias.</p>
    </div>

    <div class="filtros-section">
      <div class="filtro-grupo">
        <label for="filtro">Filtrar por: </label>
        <select id="filtro" v-model="filtroSeleccionado" class="filtro-select">
          <option value="TODOS">Todas las mascotas</option>
          <option value="PERDIDA">Perdidas</option>
          <option value="ENCONTRADA">Encontradas</option>
        </select>
      </div>

      <div class="filtro-grupo">
        <label for="orden">Ordenar por fecha: </label>
        <select id="orden" v-model="ordenFecha" class="filtro-select">
          <option value="DESC">Más recientes primero</option>
          <option value="ASC">Más antiguas primero</option>
        </select>
      </div>
    </div>

    <div v-if="cargando" class="estado-mensaje loader">
      <p>Cargando información desde el orquestador...</p>
    </div>

    <div v-else-if="error" class="estado-mensaje error">
      <p>Ocurrió un problema de conexión: {{ error }}</p>
      <button @click="obtenerMascotas" class="btn-reintentar">Reintentar</button>
    </div>

    <div v-else class="mascotas-grid">
      <MascotaCard v-for="mascota in mascotasFiltradas" :key="mascota.id" :mascota="mascota" />
    </div>

    <div v-if="!cargando && !error && mascotasFiltradas.length === 0" class="estado-mensaje vacio">
      <p>No se encontraron mascotas con estos criterios.</p>
    </div>
  </div>
</template>

<script setup>
import { ref, onMounted, computed } from 'vue';
import api from '../api/axiosConfig.js';
import MascotaCard from '../components/mascotas/MascotaCard.vue';

const mascotas = ref([]);
const cargando = ref(true);
const error = ref(null);
const filtroSeleccionado = ref('TODOS');
// NUEVO: Estado para el ordenamiento (por defecto mostramos lo más nuevo primero)
const ordenFecha = ref('DESC'); 

const obtenerMascotas = async () => {
  cargando.value = true;
  error.value = null;
  try {
    const response = await api.get('/web/mascotas');

    const data = response.data.content || response.data;
    mascotas.value = Array.isArray(data) ? data : [];

    console.log("Mascotas cargadas:", mascotas.value);
  } catch (err) {
    console.error("Error al cargar mascotas:", err);
    error.value = err.message || "No se pudo conectar con el servidor.";
  } finally {
    cargando.value = false;
  }
};

// MODIFICADO: Ahora filtra y luego ordena
const mascotasFiltradas = computed(() => {
  // 1. Aplicamos el filtro por tipo
  let resultado = mascotas.value;
  if (filtroSeleccionado.value !== 'TODOS') {
    resultado = resultado.filter(m => m.tipoReporte === filtroSeleccionado.value);
  }

  // 2. Aplicamos el ordenamiento por fecha
  // Nota: Usamos [...resultado] (o resultado ya filtrado) para no mutar el array original
  return resultado.sort((a, b) => {
    // Si no hay fecha, usamos 0 como fallback para evitar errores
    const fechaA = new Date(a.fechaReporte || 0).getTime();
    const fechaB = new Date(b.fechaReporte || 0).getTime();

    if (ordenFecha.value === 'DESC') {
      return fechaB - fechaA; // DESC: Los más grandes (recientes) primero
    } else {
      return fechaA - fechaB; // ASC: Los más pequeños (antiguos) primero
    }
  });
});

onMounted(obtenerMascotas);
</script>

<style scoped>
.dashboard-container {
  padding: 1rem 0;
}

.header-section {
  text-align: center;
  margin-bottom: 2rem;
}

.header-section h2 {
  color: var(--color-primary, #2c3e50);
  font-size: 2.2rem;
  margin-bottom: 0.5rem;
}

.header-section p {
  color: #6c757d;
  font-size: 1.1rem;
}

/* NUEVO CSS: Mejorando la sección de filtros con Flexbox */
.filtros-section {
  display: flex;
  justify-content: center;
  gap: 2rem; /* Espacio entre los grupos de filtros */
  margin-bottom: 2rem;
  flex-wrap: wrap; /* Para que en móviles se pongan uno debajo del otro */
}

.filtro-grupo {
  display: flex;
  align-items: center;
  background: white;
  padding: 0.5rem 1rem;
  border-radius: 8px;
  box-shadow: 0 2px 4px rgba(0,0,0,0.05);
}

.filtro-grupo label {
  font-weight: 600;
  color: #4a5568;
}

.filtro-select {
  padding: 0.4rem 0.8rem;
  border-radius: 6px;
  border: 1px solid #cbd5e0;
  font-size: 0.95rem;
  margin-left: 0.8rem;
  outline: none;
  background-color: #f8f9fa;
  cursor: pointer;
  transition: border-color 0.2s ease;
}

.filtro-select:focus, .filtro-select:hover {
  border-color: var(--color-primary, #2c3e50);
}

.mascotas-grid {
  display: grid;
  grid-template-columns: repeat(auto-fill, minmax(300px, 1fr));
  gap: 2rem;
}

.estado-mensaje {
  text-align: center;
  padding: 3rem;
  border-radius: 12px;
  background-color: white;
  box-shadow: 0 4px 6px rgba(0, 0, 0, 0.05);
  font-size: 1.2rem;
}

.error {
  color: #dc3545;
  border: 1px solid #f5c6cb;
}

.btn-reintentar {
  margin-top: 1rem;
  padding: 0.5rem 1.5rem;
  background-color: var(--color-primary, #007bff);
  color: white;
  border: none;
  border-radius: 8px;
  cursor: pointer;
  font-weight: 600;
}

.btn-reintentar:hover {
  opacity: 0.9;
}
</style>