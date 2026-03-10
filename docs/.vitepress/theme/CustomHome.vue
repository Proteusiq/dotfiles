<script setup>
import DefaultTheme from 'vitepress/theme'
import HomeHeroImage from './HomeHeroImage.vue'

const { Layout } = DefaultTheme
</script>

<template>
  <Layout>
    <template #home-hero-image>
      <HomeHeroImage />
    </template>
  </Layout>
</template>
