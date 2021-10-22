<template>
    <div>
        <video ref="video" autoplay loop muted playsinline class="w-screen h-screen object-cover"
               @click="play" :key="file">
            <source :src="file" type="video/mp4">
            Sorry, your browser doesn't support embedded videos.
        </video>

        <div class="fixed bottom-0 left-0 p-4">

            <div class="mb-8 sm:mx-auto sm:w-full sm:max-w-md" v-if="show">
                <div class="bg-white p-4 shadow sm:rounded-lg sm:px-10 rounded">
                    <form class="space-y-6" action="#" method="POST">
                        <div v-if="tooFast">
                            Too fast!
                        </div>
                        <div v-if="tooSlow">
                            Too slow!
                        </div>

                        <t-input v-model="tempo" label="Tempo"/>
                        <t-input v-model="timeSignature" label="Time Signature"/>
                        <t-input v-model="nodsPerBar" label="Beats Per Bar"/>

                        <div class="block text-sm font-medium text-gray-700">
                            Playback Rate: {{ playbackRate.toPrecision(2) }}
                        </div>

                        <div class="flex flex-col">
                            <button v-for="(asset, index) of assets" :key="asset.file"
                                    @click.prevent="selectedAsset = index"
                                    class="py-2 px-3 mt-2 text-left bg-indigo-200 rounded focus:outline-none"
                                    :class="{'ring': selectedAsset === index}">
                                {{ asset.name }}
                            </button>
                        </div>
                    </form>
                </div>
            </div>

            <button type="button" @click="show = !show"
                    class="inline-flex items-center p-1 border border-transparent rounded-full shadow-sm text-white bg-indigo-600 hover:bg-indigo-700 focus:outline-none focus:ring-2 focus:ring-offset-2 focus:ring-indigo-500">
                <icon class="h-5 w-5" type="mdi" :path="mdiDotsHorizontal"></icon>
            </button>

        </div>
    </div>
</template>

<script lang="ts">
import {computed, defineComponent, onMounted, ref, Ref, watch} from 'vue'
import {mdiDotsHorizontal} from '@mdi/js';
import TInput from "./components/TInput.vue";

export default defineComponent({
    name: 'App',
    components: {TInput},
    setup() {
        const bpm = 121;
        const video: Ref<HTMLVideoElement | null> = ref(null);
        const show = ref(false);
        const tooFast = ref(false);
        const tooSlow = ref(false);
        const tempo = ref(121);
        const timeSignature = ref(4);
        const nodsPerBar = ref(4);
        const playbackRate = computed(() => {
            return (tempo.value / bpm) / (timeSignature.value / nodsPerBar.value);
        })

        const selectedAsset = ref(0);
        const assets = [
            {name: 'Cat', file: '/catvibe.mp4'},
            {name: 'Step Grandma', file: '/step-grandma.mp4'}
        ]
        const file = computed(() => assets[selectedAsset.value].file)

        watch(() => playbackRate.value, (newValue) => {
            if (!video.value) {
                return;
            }

            updatePlaybackRate(newValue)
        })

        const play = () => video.value?.play();

        const updatePlaybackRate = (rate: number) => {
            if (video.value === null) {
                return;
            }

            if (rate < 0.1) {
                tooSlow.value = true;
                video.value.playbackRate = 0.1
                return;
            }

            if (rate > 10) {
                tooFast.value = true;
                video.value.playbackRate = 10
                return;
            }

            tooFast.value = false;
            tooSlow.value = false;
            video.value.playbackRate = rate
        };

        onMounted(() => updatePlaybackRate(playbackRate.value))

        return {
            video,
            show,
            tooFast,
            tooSlow,
            tempo,
            timeSignature,
            nodsPerBar,
            playbackRate,
            mdiDotsHorizontal,
            play,
            selectedAsset,
            assets,
            file
        }
    }
})
</script>

<style>
</style>
