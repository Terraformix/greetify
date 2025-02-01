<template>
  <section class="min-h-screen w-full soft-bg py-12 px-4">
    <div class="max-w-7xl mx-auto bg-white rounded-3xl p-8 md:p-12 shadow-2xl">
      <h1 class="text-4xl md:text-6xl text-center font-bold text-gray-800 mb-4 tracking-tight">
        Welcome to Greetify!
      </h1>
      <p class="text-xl text-center text-gray-600 mb-12">
        Explore greetings from different cultures and languages.
      </p>
     
      <div class="bg-gray-50 rounded-2xl p-6 mb-12 max-w-2xl mx-auto shadow-inner">
        <div class="flex flex-col md:flex-row gap-4">
          <input
            v-model="language"
            type="text"
            placeholder="Enter language"
            class="w-full md:w-1/3 px-4 py-3 rounded-xl bg-white shadow-sm border border-gray-200 text-gray-800 placeholder-gray-400 outline-none"
          />
          <input
            v-model="greeting"
            type="text"
            placeholder="Enter greeting"
            class="w-full md:w-1/3 px-4 py-3 rounded-xl bg-white shadow-sm border border-gray-200 text-gray-800 placeholder-gray-400 outline-none"
          />
          <button
            @click="addNewGreeting"
            :disabled="!language || !greeting"
            :class="[
              'w-full md:w-1/3 px-6 py-3 rounded-xl font-medium transition-all duration-300',
              (!language || !greeting)
                ? 'bg-gray-100 cursor-not-allowed text-gray-400'
                : 'bg-blue-500 hover:bg-blue-600 text-white shadow-lg hover:shadow-xl hover:-translate-y-0.5'
            ]"
          >
            Add Greeting
          </button>
        </div>

        <div v-if="!isStatic" class="mt-4 flex items-center gap-2">
          <input
            type="checkbox"
            v-model="skipValidityCheck"
            class="w-4 h-4 text-blue-500 rounded border-gray-300 focus:ring-blue-500"
          />
          <label class="text-gray-700">Skip language validation</label>
        </div>
      </div>
      <div v-if="greetings.length > 0" class="grid grid-cols-1 sm:grid-cols-2 md:grid-cols-3 lg:grid-cols-4 gap-4">
        <GreetingCard
          v-for="(item, index) in greetings"
          :key="index"
          :id="item.id"
          :language="item.language"
          :greeting="item.greeting"
          @delete="deleteGreeting(item.id)"
        />
      </div>

      <div v-else className="flex flex-col items-center justify-center p-16 bg-gray-100 rounded-xl text-gray-100">
        <h2 className="text-xl font-medium mb-2 text-gray-900">Nothing to see yet</h2>
        <p className="text-gray-400 text-center">Your greetings collection is waiting to be filled</p>
      </div>
    </div>
  </section>
</template>
<script setup>
import { onBeforeMount, ref } from 'vue'
import { makeApiCall } from '../src/utils/api/makeApiCall.js'
import GreetingCard from './components/GreetingCard.vue';
import { toast } from "vue3-toastify";
import inMemoryGreetings from './data/greetings.js';

const greetings = ref([]);
const hostname = ref('');
const language = ref('');
const greeting = ref('');
const isStatic = import.meta.env.VITE_IS_STATIC === 'true';
const skipValidityCheck = ref(false);


onBeforeMount(async () => {

  if (isStatic) {
    greetings.value = inMemoryGreetings.sort((a, b) => b.id - a.id);
  } else {
    const data = await makeApiCall("GET", "/api/greetings");
    greetings.value = data.greetings.sort((a, b) => b.id - a.id);
    hostname.value = data.hostname;
  }
});

const addNewGreeting = async () => {
  try {    
    const newEntry = { language: language.value, greeting: greeting.value, skipValidityCheck: skipValidityCheck.value };

    if (isStatic) {
      if (greetings.value.some(item => item.language === language.value)) {
        toast.error("Greeting already exists for this language.");
      } else {
        const newId = greetings.value.length + 1;
        greetings.value.unshift({ ...newEntry, id: newId });
        toast.success("Greeting added successfully to the in-memory list.");
      }
    } else {
      const response = await makeApiCall("POST", "/api/greetings", newEntry);
      if (response?.success) {
        greetings.value.unshift(response.data);
        toast.success("Greeting added successfully to the database.");
      } else {
        handleError(response);
      }
    }

    language.value = '';
    greeting.value = '';
  } catch (error) {
    console.error('Add greeting failed:', error);
    toast.error("An unexpected error occurred.");
  }
};

const deleteGreeting = async (id) => {
  try {
    const response = !isStatic && await makeApiCall("DELETE", `/api/greetings/${id}`);

    if (response.success || isStatic) {
      greetings.value = greetings.value.filter(item => item.id !== id);
      toast.success("Greeting deleted successfully.");
    } else {
      handleError(response);
    }
  } catch (error) {
    console.error("Error deleting greeting:", error);
    toast.error("An unexpected error occurred while deleting the greeting.");
  }
};

const handleError = async (response) => {
  const errorData = await response.json();
  console.error("Error:", errorData.error);
  toast.error(errorData.error || "An unexpected error occurred.");
};
</script>

<style>
.soft-bg {
  background-color: #f8fafc;
  background-image: 
    radial-gradient(circle at 80% 20%, #f7f8ff 0%, transparent 25%),
    radial-gradient(circle at 20% 80%, #d8eaff 0%, transparent 25%);
}

.soft-input {
  transition: all 0.2s ease;
}

.soft-input:focus {
  border-color: #f43f5e;
  box-shadow: 0 0 0 4px rgba(244, 63, 94, 0.1);
  transform: translateY(-1px);
}

@keyframes float {
  0% { transform: translateY(0px); }
  50% { transform: translateY(-5px); }
  100% { transform: translateY(0px); }
}

.hover-float:hover {
  animation: float 2s ease-in-out infinite;
}
</style>
