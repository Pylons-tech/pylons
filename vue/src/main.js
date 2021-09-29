import { createApp } from 'vue'
import { createVuetify } from 'vuetify'
import App from './App.vue'
import router from './router'
import store from './store'

const app = createApp(App)
const vuetify = createVuetify() // Replaces new Vuetify(...)

app.use(router)
app.use(store)
app.use(vuetify)

app.mount('#app')
