// import 'vuetify/styles'
import { createApp } from 'vue'
import { createVuetify } from 'vuetify'
import App from './App.vue'
import router from './router'
import vueLib from '@starport/vue'
import store from './store'


const app = createApp(App)
const vuetify = createVuetify() // Replaces new Vuetify(...)

app.config.globalProperties._depsLoaded = true
app.use(store)
app.use(router)
app.use(vueLib)
app.use(vuetify)
app.mount('#app')
