import { defineConfig } from 'vite'
import vue from '@vitejs/plugin-vue'

export default defineConfig({
  plugins: [vue()],
  server: {
    host: '0.0.0.0',
    port: 3000,
    watch: {
      usePolling: true,
      interval: 1000,
      followSymlinks: false
    },
    hmr: {
      host: 'localhost',
      port: 3000
    }
  },
  preview: {
    host: '0.0.0.0',
    port: 3000
  },
  optimizeDeps: {
    force: true
  }
}) 