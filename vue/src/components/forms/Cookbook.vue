<template>
  <div id="cookbookForm" class="form-group">
    <input type="text" v-model="id" placeholder="edit me" />
    <input type="text" v-model="nodeVersion" placeholder="edit me" />
    <input type="text" v-model="name" placeholder="edit me" />
    <input type="text" v-model="description" placeholder="edit me" />
    <input type="text" v-model="developer" placeholder="edit me" />
    <input type="text" v-model="version" placeholder="edit me" />
    <input type="text" v-model="supportEmail" placeholder="edit me" />
    <input type="button" @click="createCookbook" />
  </div>
</template>

<script>
export default {
  name: 'Cookbook',
  data () {
    return {
      id: '',
      nodeVersion: '',
      name: '',
      description: '',
      developer: '',
      version: '',
      supportEmail: ''
    }
  },
  methods: {
    createCookbook() {
      alert('cliquei!')
    }
  },
}
</script>
