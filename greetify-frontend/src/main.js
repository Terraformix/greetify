import { createApp } from 'vue';
import VuejsDialog from 'vuejs-dialog';
import AppComponent from './App.vue'
import 'vuejs-dialog/dist/vuejs-dialog.min.css';
import 'vue3-toastify/dist/index.css'; 


const app = createApp(AppComponent)
app.use(VuejsDialog);
app.mount('#app')
