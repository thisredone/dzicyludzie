<template>

  <div class="p-8 flex flex-col">
    <div class="text-2xl pb-6 font-heading text-accent-200">My links</div>
    <div v-for="link in history" class="flex justify-between text-lg leading-loose tracking-widest mb-2">
      <div class="pr-24">{{ link.path }}</div>
      <div class="flex">
        <div v-if="link.paid" class="bg-light-600 px-2 rounded-sm">paid ✓</div>
        <div v-if="!link.paid" class="bg-accent-300 px-2 rounded-sm">pending</div>
        <button @click="remove(link.path)" class="ml-4 bg-dark-300 text-accent-500 hover:text-accent-800 px-3 focus:outline-none rounded-sm">X</button>
      </div>
    </div>

    <button @click="$emit('create-new')" class="focus:outline-none py-2 px-4 mt-10 text-xl bg-action-300 hover:bg-action-200 self-end rounded-sm">
      Create new
    </button>
  </div>

</template>


<script lang="coffee">

export default
  props: ['history']

  methods:
    remove: (path) ->
      db.collection('links').doc(path).delete()
      @$emit 'removed', path

</script>
