<script setup>
import { ref, onMounted, onUnmounted } from 'vue'

const leftPupilX = ref(36)
const leftPupilY = ref(50)
const rightPupilX = ref(60)
const rightPupilY = ref(50)

const leftEyeCenterX = 38
const leftEyeCenterY = 52
const rightEyeCenterX = 62
const rightEyeCenterY = 52
const maxPupilOffset = 4

function handleMouseMove(event) {
  const fox = document.querySelector('.fox-interactive')
  if (!fox) return

  const rect = fox.getBoundingClientRect()
  const foxCenterX = rect.left + rect.width / 2
  const foxCenterY = rect.top + rect.height / 2

  const deltaX = event.clientX - foxCenterX
  const deltaY = event.clientY - foxCenterY
  const distance = Math.sqrt(deltaX * deltaX + deltaY * deltaY)
  
  const normalizedX = distance > 0 ? deltaX / distance : 0
  const normalizedY = distance > 0 ? deltaY / distance : 0
  
  const scale = Math.min(distance / 200, 1)
  const offsetX = normalizedX * maxPupilOffset * scale
  const offsetY = normalizedY * maxPupilOffset * scale

  leftPupilX.value = leftEyeCenterX - 2 + offsetX
  leftPupilY.value = leftEyeCenterY - 2 + offsetY
  rightPupilX.value = rightEyeCenterX - 2 + offsetX
  rightPupilY.value = rightEyeCenterY - 2 + offsetY
}

onMounted(() => {
  window.addEventListener('mousemove', handleMouseMove)
})

onUnmounted(() => {
  window.removeEventListener('mousemove', handleMouseMove)
})
</script>

<template>
  <ClientOnly>
    <svg class="fox-interactive" xmlns="http://www.w3.org/2000/svg" viewBox="0 0 100 100">
      <defs>
        <linearGradient id="foxGradientHero" x1="0%" y1="0%" x2="100%" y2="100%">
          <stop offset="0%" style="stop-color:#f97316"/>
          <stop offset="100%" style="stop-color:#ea580c"/>
        </linearGradient>
      </defs>
      <!-- Fox face -->
      <path d="M50 15 L20 45 L25 80 L50 90 L75 80 L80 45 Z" fill="url(#foxGradientHero)"/>
      <!-- Left ear -->
      <path d="M20 45 L10 20 L35 35 Z" fill="url(#foxGradientHero)"/>
      <!-- Right ear -->
      <path d="M80 45 L90 20 L65 35 Z" fill="url(#foxGradientHero)"/>
      <!-- Inner left ear -->
      <path d="M22 42 L15 25 L32 36 Z" fill="#fbbf24"/>
      <!-- Inner right ear -->
      <path d="M78 42 L85 25 L68 36 Z" fill="#fbbf24"/>
      <!-- White face patch -->
      <path d="M50 50 L35 60 L40 80 L50 85 L60 80 L65 60 Z" fill="#fff"/>
      <!-- Left eye (dark) -->
      <ellipse cx="38" cy="52" rx="6" ry="7" fill="#1e293b"/>
      <!-- Right eye (dark) -->
      <ellipse cx="62" cy="52" rx="6" ry="7" fill="#1e293b"/>
      <!-- Left pupil (animated) -->
      <circle :cx="leftPupilX" :cy="leftPupilY" r="2.5" fill="#fff" class="pupil"/>
      <!-- Right pupil (animated) -->
      <circle :cx="rightPupilX" :cy="rightPupilY" r="2.5" fill="#fff" class="pupil"/>
      <!-- Nose -->
      <ellipse cx="50" cy="70" rx="5" ry="4" fill="#1e293b"/>
      <!-- Mouth -->
      <path d="M50 74 L50 78 M45 80 Q50 84 55 80" stroke="#1e293b" stroke-width="2" fill="none" stroke-linecap="round"/>
    </svg>
  </ClientOnly>
</template>

<style scoped>
.fox-interactive {
  width: 320px;
  height: 320px;
  max-width: 100%;
}

.pupil {
  transition: cx 0.08s ease-out, cy 0.08s ease-out;
}

@media (min-width: 640px) {
  .fox-interactive {
    width: 375px;
    height: 375px;
  }
}

@media (min-width: 960px) {
  .fox-interactive {
    width: 420px;
    height: 420px;
  }
}
</style>
