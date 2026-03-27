import { defineConfig } from 'vite'
import react from '@vitejs/plugin-react'

export default defineConfig({
  plugins: [react()],
  base: './',
  build: {
    outDir: 'dist',   // ✅ FORCE output folder
    minify: 'esbuild',
    target: 'esnext',
    cssMinify: true,
    rollupOptions: {
      output: {
        manualChunks: {
          vendor: ['react', 'react-dom'],
          animations: ['./src/animations/CinematicIntro.jsx', './src/animations/BackgroundEffects.jsx'],
        },
      },
    },
  },
  optimizeDeps: {
    include: ['react', 'react-dom', 'axios', 'react-dropzone'],
  },
})