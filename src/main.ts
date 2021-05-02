import { createApp } from 'vue'
import App from './App.vue'
import './index.css'
import Icon from '@jamescoyle/vue-icon'

createApp(App).component('icon', Icon).mount('#app')
