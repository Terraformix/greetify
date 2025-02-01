import { defineConfig } from 'vite';
import vue from '@vitejs/plugin-vue';

export default defineConfig({
  plugins: [vue()],
  server: {
    proxy: {
      // Proxy /api requests to the backend server in development
      '/api': {
        target: 'http://localhost:8080',
        changeOrigin: true
      },
    },
  },
});
