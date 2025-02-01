<template>
  <div class="greeting-card" @click="handleDeleteClick(id)">
    <div class="card-content">
      <h2 class="language">{{ language }}</h2>
      <p class="greeting">{{ greeting }}</p>
    </div>
  </div>
</template>

<script setup>
import { makeApiCall } from '../utils/api/makeApiCall';
const emit = defineEmits(['delete'])
const isStatic = import.meta.env.VITE_IS_STATIC === 'true';


defineProps({
    id: Number,
    language: String,
    greeting: String
})


const handleDeleteClick = async (id) => {
  try {
    const response = !isStatic && await makeApiCall("GET", `/api/greetings/${id}`);

    if (response?.greeting || isStatic) {
      const confirmed = window.confirm('Are you sure you want to delete this record?');
      
      if (confirmed) {
        emit('delete', id);
      }
    } else {
      console.warn("No greeting found for this record.");
    }
  } catch (error) {
    console.error("Error fetching the greeting:", error);
  }
}

</script>

<style scoped>
.greeting-card {
  background: white;
  padding: 1.5rem;
  border-radius: 16px;
  text-align: left;
  cursor: pointer;
  transition: all 0.3s ease;
  position: relative;
  border: 2px solid #f3f4f6;
}

.card-content {
  position: relative;
  z-index: 2;
}

.greeting-card::before {
  content: '';
  position: absolute;
  top: 1rem;
  right: 1rem;
  width: 20px;
  height: 20px;
  border-radius: 50%;
  background: #3B82F6;
  transition: all 0.3s ease;
  opacity: 0.1;
}

.greeting-card:hover {
  border-color: #3B82F6;
}

.greeting-card:hover::before {
  transform: scale(10);
  opacity: 0.05;
}

.language {
  font-size: 1.25rem;
  font-weight: 700;
  color: #1F2937;
  margin-bottom: 0.5rem;
  overflow-wrap: break-word; /* Prevents long words from overflowing */
}

.greeting {
  font-size: 1rem;
  color: #6B7280;
  overflow-wrap: break-word; /* Wrap long words */
  word-break: break-word; /* For older browsers */
  white-space: pre-wrap; /* Preserve line breaks and whitespace */
  max-height: 5rem; /* Optional: Limit the height */
  overflow: hidden; /* Hide overflowing text */
  text-overflow: ellipsis; /* Add ellipsis for overflowing text */
}
</style>
