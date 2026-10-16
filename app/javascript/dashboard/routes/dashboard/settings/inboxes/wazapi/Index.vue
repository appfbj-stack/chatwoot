<template>
  <div class="wazapi-setup">
    <h2 class="text-2xl font-bold text-emerald-500 mb-2">Conectar WhatsApp via Wazapi</h2>
    <p class="text-slate-400 mb-6">
      Wazapi é uma API self-hosted de WhatsApp. Você precisa de uma instância rodando.
      <a href="https://github.com/wazapilabs/wazapi" target="_blank" class="text-emerald-400 hover:text-emerald-300">
        Ver documentação →
      </a>
    </p>

    <form @submit.prevent="submit" class="space-y-4 max-w-xl">
      <div>
        <label class="block text-sm font-medium text-slate-300 mb-1">URL da instância Wazapi</label>
        <input
          v-model="form.baseUrl"
          type="url"
          required
          placeholder="http://wazapi.exemplo.com:8080"
          class="w-full bg-slate-900 border border-slate-700 rounded-lg px-4 py-2 text-slate-100 focus:border-emerald-500 focus:ring-2 focus:ring-emerald-500/50 focus:outline-none"
        />
      </div>

      <div>
        <label class="block text-sm font-medium text-slate-300 mb-1">Instance ID</label>
        <input
          v-model="form.instanceId"
          type="text"
          required
          placeholder="kairos-prod-01"
          class="w-full bg-slate-900 border border-slate-700 rounded-lg px-4 py-2 text-slate-100 focus:border-emerald-500 focus:ring-2 focus:ring-emerald-500/50 focus:outline-none"
        />
      </div>

      <div>
        <label class="block text-sm font-medium text-slate-300 mb-1">API Token</label>
        <input
          v-model="form.apiToken"
          type="password"
          required
          placeholder="••••••••••••"
          class="w-full bg-slate-900 border border-slate-700 rounded-lg px-4 py-2 text-slate-100 focus:border-emerald-500 focus:ring-2 focus:ring-emerald-500/50 focus:outline-none"
        />
      </div>

      <div>
        <label class="block text-sm font-medium text-slate-300 mb-1">Número do WhatsApp Business</label>
        <input
          v-model="form.phoneNumber"
          type="tel"
          required
          placeholder="+55 11 9 9999-9999"
          class="w-full bg-slate-900 border border-slate-700 rounded-lg px-4 py-2 text-slate-100 focus:border-emerald-500 focus:ring-2 focus:ring-emerald-500/50 focus:outline-none"
        />
      </div>

      <div>
        <label class="block text-sm font-medium text-slate-300 mb-1">Webhook Secret (opcional, gerado se vazio)</label>
        <input
          v-model="form.webhookSecret"
          type="text"
          placeholder="auto-gerado"
          class="w-full bg-slate-900 border border-slate-700 rounded-lg px-4 py-2 text-slate-100 focus:border-emerald-500 focus:ring-2 focus:ring-emerald-500/50 focus:outline-none"
        />
      </div>

      <div v-if="error" class="bg-red-500/10 border border-red-500/50 text-red-400 rounded-lg px-4 py-3">
        {{ error }}
      </div>

      <div class="flex gap-3 pt-4">
        <button
          type="submit"
          :disabled="loading"
          class="px-6 py-2 bg-emerald-500 hover:bg-emerald-400 text-slate-900 font-semibold rounded-lg shadow-[0_0_24px_rgba(16,185,129,0.5)] hover:shadow-[0_0_40px_rgba(16,185,129,0.7)] transition-all disabled:opacity-50 disabled:cursor-not-allowed"
        >
          {{ loading ? 'Criando...' : 'Criar Inbox' }}
        </button>
        <button
          type="button"
          @click="$router.back()"
          class="px-6 py-2 bg-slate-700 hover:bg-slate-600 text-slate-100 rounded-lg transition-colors"
        >
          Cancelar
        </button>
      </div>
    </form>

    <div v-if="created" class="mt-8 bg-emerald-500/10 border border-emerald-500/50 rounded-lg p-6">
      <h3 class="text-lg font-semibold text-emerald-400 mb-2">✓ Inbox criada com sucesso!</h3>
      <p class="text-slate-300 mb-3">Configure o webhook na sua instância Wazapi apontando para:</p>
      <code class="block bg-slate-900 border border-slate-700 rounded px-3 py-2 text-emerald-300 font-mono text-sm mb-2">
        POST {{ webhookUrl }}
      </code>
      <p class="text-slate-400 text-sm">
        Header: <code class="text-emerald-300">X-Wazapi-Signature: HMAC-SHA256({{ form.webhookSecret || 'auto' }}, body)</code>
      </p>
    </div>
  </div>
</template>

<script setup>
import { ref, reactive } from 'vue';
import { useStore } from 'vuex';

const store = useStore();
const loading = ref(false);
const error = ref('');
const created = ref(false);
const webhookUrl = ref('');

const form = reactive({
  baseUrl: '',
  instanceId: '',
  apiToken: '',
  phoneNumber: '',
  webhookSecret: '',
});

const submit = async () => {
  loading.value = true;
  error.value = '';
  try {
    const response = await store.dispatch('inboxes/createWazapi', form);
    webhookUrl.value = response.webhook_url;
    created.value = true;
  } catch (e) {
    error.value = e.message || 'Erro ao criar inbox Wazapi';
  } finally {
    loading.value = false;
  }
};
</script>

<style scoped>
.wazapi-setup {
  @apply p-6 max-w-3xl mx-auto;
}
</style>
