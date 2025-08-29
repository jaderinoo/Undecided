<template>
  <v-app>
    <v-main class="black-background" @click="createPoof">
      <div id="snow" data-count="200"></div>
      
      <!-- Poof effects -->
      <div
        v-for="poof in poofs"
        :key="poof.id"
        class="poof"
        :style="{
          left: poof.x + 'px',
          top: poof.y + 'px'
        }"
      ></div>
      
      <div class="welcome-container">
        <h1 class="welcome-title">welcome home, friend</h1>
        
        <div class="cards-container">
          <div class="cards-grid">
            <!-- Top row: Jellyfin and Bitwarden -->
            <div class="top-row">
              <v-card
                class="app-card flat-button top-card"
                elevation="0"
                hover
                @click="navigateToApp(apps[0].url)"
                height="120"
              >
                <v-card-text class="text-center pa-4">
                  <div class="app-header">
                    <v-icon
                      :icon="apps[0].icon"
                      size="32"
                      color="white"
                      class="mb-3"
                    ></v-icon>
                    <div v-if="apps[0].vpnRequired" class="vpn-tag">VPN Required</div>
                  </div>
                  <h3 class="app-title">{{ apps[0].name }}</h3>
                  <p class="app-description">{{ apps[0].description }}</p>
                </v-card-text>
              </v-card>
              
              <v-card
                class="app-card flat-button top-card"
                elevation="0"
                hover
                @click="navigateToApp(apps[1].url)"
                height="120"
              >
                <v-card-text class="text-center pa-4">
                  <div class="app-header">
                    <v-icon
                      :icon="apps[1].icon"
                      size="32"
                      color="white"
                      class="mb-3"
                    ></v-icon>
                    <div v-if="apps[1].vpnRequired" class="vpn-tag">VPN Required</div>
                  </div>
                  <h3 class="app-title">{{ apps[1].name }}</h3>
                  <p class="app-description">{{ apps[1].description }}</p>
                </v-card-text>
              </v-card>
            </div>
            
            <!-- Bottom row: Portainer, Pi-hole, Tabby, Glance -->
            <div class="bottom-row">
              <v-card
                v-for="app in apps.slice(2)"
                :key="app.id"
                class="app-card flat-button bottom-card"
                elevation="0"
                hover
                @click="navigateToApp(app.url)"
                height="120"
              >
                <v-card-text class="text-center pa-4">
                  <div class="app-header">
                    <v-icon
                      :icon="app.icon"
                      size="32"
                      color="white"
                      class="mb-3"
                    ></v-icon>
                    <div v-if="app.vpnRequired" class="vpn-tag">VPN Required</div>
                  </div>
                  <h3 class="app-title">{{ app.name }}</h3>
                  <p class="app-description">{{ app.description }}</p>
                </v-card-text>
              </v-card>
            </div>
          </div>
        </div>
      </div>
    </v-main>
  </v-app>
</template>

<script>
import { ref, onMounted } from 'vue'
import { createSnow, showSnow } from 'pure-snow.js'
import 'pure-snow.js/style.css'

export default {
  name: 'App',
  setup() {
    const apps = ref([
      {
        id: 1,
        name: 'Jellyfin',
        description: 'Media server and streaming',
        icon: 'mdi-play-circle',
        url: 'https://jellyfin.undecided.dev',
        vpnRequired: false
      },
      {
        id: 2,
        name: 'Bitwarden',
        description: 'Password manager',
        icon: 'mdi-key',
        url: 'https://passwords.undecided.dev',
        vpnRequired: true
      },
      {
        id: 3,
        name: 'Portainer',
        description: 'Docker container management',
        icon: 'mdi-docker',
        url: 'https://192.168.50.100:9443/#!/auth',
        vpnRequired: true
      },
      {
        id: 4,
        name: 'Pi-hole',
        description: 'Network-wide ad blocking',
        icon: 'mdi-shield-off',
        url: 'http://192.168.50.100:8080/admin/login',
        vpnRequired: true
      },
      {
        id: 5,
        name: 'Tabby',
        description: 'AI coding assistant',
        icon: 'mdi-robot',
        url: 'http://192.168.50.100:5252',
        vpnRequired: true
      },
      {
        id: 6,
        name: 'Glance',
        description: 'Quick overview dashboard',
        icon: 'mdi-eye',
        url: 'http://192.168.50.100:61208',
        vpnRequired: true
      }
    ])

    const poofs = ref([])

    const createPoof = (event) => {
      // Only create poof if clicking on empty space, not on buttons or interactive elements
      if (event.target.classList.contains('app-card') || 
          event.target.closest('.app-card') || 
          event.target.classList.contains('v-card') ||
          event.target.closest('.v-card')) {
        return; // Don't create poof on buttons
      }
      
      const poof = {
        id: Date.now(),
        x: event.clientX,
        y: event.clientY,
        createdAt: Date.now()
      }
      
      poofs.value.push(poof)
      
      // Remove poof after animation completes
      setTimeout(() => {
        const index = poofs.value.findIndex(p => p.id === poof.id)
        if (index > -1) {
          poofs.value.splice(index, 1)
        }
      }, 750)
    }

    const navigateToApp = (url) => {
      // Open the URL in a new tab
      window.open(url, '_blank')
    }

    onMounted(() => {
      // Initialize the snow effect
      createSnow()
      showSnow(true)
    })

    return {
      apps,
      navigateToApp,
      poofs,
      createPoof
    }
  }
}
</script>

<style>
.black-background {
  background-color: #000000 !important;
  height: 100vh;
  position: relative;
  overflow: hidden;
}

#snow {
  position: fixed;
  top: 0;
  left: 0;
  width: 100%;
  height: 100%;
  pointer-events: none;
  z-index: 1;
}

/* Simple snow glow effect */
#snow .snowflake {
  box-shadow: 0 0 100px rgba(255, 255, 255, 1);
}

/* Poof effect */
.poof {
  position: fixed;
  width: 20px;
  height: 20px;
  background: radial-gradient(circle, rgba(255, 255, 255, 0.6) 0%, rgba(255, 255, 255, 0.4) 50%, rgba(255, 255, 255, 0.2) 100%);
  border-radius: 50%;
  pointer-events: none;
  z-index: 9999;
  transform: translate(-50%, -50%);
  animation: poofAnimation 0.75s ease forwards;
  box-shadow: 0 0 10px rgba(255, 255, 255, 0.4);
}



@keyframes poofAnimation {
  0% {
    opacity: 0.6;
    transform: translate(-50%, -50%) scale(0.1);
  }
  50% {
    opacity: 0.4;
    transform: translate(-50%, -50%) scale(1.2);
  }
  100% {
    opacity: 0;
    transform: translate(-50%, -50%) scale(1.5);
  }
}

.welcome-container {
  display: flex;
  flex-direction: column;
  align-items: center;
  justify-content: flex-start;
  height: 100vh;
  padding: 2rem;
  padding-top: 15vh;
  position: relative;
  z-index: 2;
}

.welcome-title {
  color: #ffffff;
  font-size: 3.5rem;
  font-weight: 300;
  text-align: center;
  margin-bottom: 2.5rem;
  letter-spacing: 2px;
  text-shadow: 
    0 0 10px rgba(255, 255, 255, 0.3),
    0 0 20px rgba(255, 255, 255, 0.2),
    0 0 30px rgba(255, 255, 255, 0.1);
  opacity: 1;
  position: relative;
  z-index: 10;
}

.cards-container {
  width: 100%;
  max-width: 1200px;
  flex: 1;
  display: flex;
  align-items: flex-end;
  justify-content: center;
  padding-bottom: 2vh;
}

.cards-grid {
  width: 100%;
  display: flex;
  flex-direction: column;
  gap: 2rem;
}

.top-row {
  display: flex;
  justify-content: center;
  gap: 2rem;
  margin-bottom: 2rem;
}

.bottom-row {
  display: flex;
  justify-content: center;
  gap: 1rem;
  flex-wrap: wrap;
}

.top-card {
  flex: 0 0 auto;
  width: 250px;
}

.bottom-card {
  flex: 0 0 auto;
  width: 250px;
}

.app-card {
  cursor: pointer;
  transition: all 0.3s ease;
  border-radius: 8px !important;
  overflow: hidden;
  background-color: rgba(0, 0, 0, 0.8) !important;
  border: 1px solid rgba(255, 255, 255, 0.1) !important;
  position: relative;
  box-shadow: none !important;
}

.app-card .v-card__content {
  border-radius: 8px !important;
}

.app-card:hover {
  transform: translateY(-1px);
  border-color: rgba(255, 255, 255, 0.25) !important;
  box-shadow: 
    0 2px 8px rgba(255, 255, 255, 0.08),
    0 0 0 1px rgba(255, 255, 255, 0.15) !important;
}

.flat-button {
  position: relative;
}

.flat-button::after {
  content: '';
  position: absolute;
  top: -1px;
  left: -1px;
  right: -1px;
  bottom: -1px;
  border-radius: 8px;
  background: linear-gradient(
    90deg,
    rgba(255, 255, 255, 0.06) 0%,
    rgba(255, 255, 255, 0.04) 20%,
    rgba(255, 255, 255, 0.02) 50%,
    rgba(255, 255, 255, 0.04) 80%,
    rgba(255, 255, 255, 0.06) 100%
  );
  z-index: -1;
  filter: blur(0.1px);
  pointer-events: none;
}

.app-header {
  position: relative;
  display: flex;
  flex-direction: column;
  align-items: center;
  margin-bottom: 0.5rem;
}

.vpn-tag {
  position: absolute;
  top: -8px;
  right: -8px;
  color: rgba(255, 255, 255, 0.8);
  font-size: 0.7rem;
  font-weight: 400;
  padding: 2px 6px;
  z-index: 5;
  text-shadow: 0 1px 2px rgba(0, 0, 0, 0.8);
}

.app-title {
  color: #cccccc;
  font-size: 1.2rem;
  font-weight: 400;
  margin-bottom: 0.3rem;
  opacity: 0.9;
}

.app-description {
  color: rgba(204, 204, 204, 0.6);
  font-size: 0.8rem;
  line-height: 1.3;
  opacity: 0.7;
}

/* Responsive adjustments */
@media (max-width: 768px) {
  .welcome-title {
    font-size: 2.5rem;
    margin-bottom: 3rem;
  }
  
  .welcome-container {
    padding: 1rem;
  }
  
  .top-row {
    flex-direction: column;
    align-items: center;
    gap: 1rem;
  }
  
  .bottom-row {
    gap: 1rem;
  }
  
  .top-card,
  .bottom-card {
    width: 100%;
    max-width: 320px;
  }
}

@media (max-width: 480px) {
  .welcome-title {
    font-size: 2rem;
    margin-bottom: 2rem;
  }
}
</style> 