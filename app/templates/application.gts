import { pageTitle } from 'ember-page-title';

<template>
  {{pageTitle "EmberLearning"}}

  <div class="min-h-screen bg-gray-50">
    {{outlet}}
  </div>
</template>
