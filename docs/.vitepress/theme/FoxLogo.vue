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
  const fox = document.querySelector('.fox-logo')
  if (!fox) return

  const rect = fox.getBoundingClientRect()
  const foxCenterX = rect.left + rect.width / 2
  const foxCenterY = rect.top + rect.height / 2

  // Calculate angle from fox center to cursor
  const deltaX = event.clientX - foxCenterX
  const deltaY = event.clientY - foxCenterY
  const distance = Math.sqrt(deltaX * deltaX + deltaY * deltaY)
  
  // Normalize and apply max offset
  const normalizedX = distance > 0 ? deltaX / distance : 0
  const normalizedY = distance > 0 ? deltaY / distance : 0
  
  // Scale based on distance (closer = less movement, further = more)
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
  <svg class="fox-logo" xmlns="http://www.w3.org/2000/svg" viewBox="0 0 100 100">
    <defs>
      <linearGradient id="foxGradient" x1="0%" y1="0%" x2="100%" y2="100%">
        <stop offset="0%" style="stop-color:#f97316"/>
        <stop offset="100%" style="stop-color:#ea580c"/>
      </linearGradient>
    </defs>
    <!-- Fox face -->
    <path d="M50 15 L20 45 L25 80 L50 90 L75 80 L80 45 Z" fill="url(#foxGradient)"/>
    <!-- Left ear -->
    <path d="M20 45 L10 20 L35 35 Z" fill="url(#foxGradient)"/>
    <!-- Right ear -->
    <path d="M80 45 L90 20 L65 35 Z" fill="url(#foxGradient)"/>
    <!-- Inner left ear -->
    <path d="M22 42 L15 25 L32 36 Z" fill="#fbbf24"/>
    <!-- Inner right ear -->
    <path d="M78 42 L85 25 L68 36 Z" fill="#fbbf24"/>
    <!-- White face patch -->
    <path d="M50 50 L35 60 L40 80 L50 85 L60 80 L65 60 Z" fill="#fff"/>
    <!-- Left eye (white) -->
    <ellipse cx="38" cy="52" rx="6" ry="7" fill="#1e293b"/>
    <!-- Right eye (white) -->
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
</template>

<style scoped>
.fox-logo {
  width: 100%;
  height: 100%;
}

.pupil {
  transition: cx 0.1s ease-out, cy 0.1s ease-out;
}
</style>
