<template>
  <v-app>
    <v-main class="black-background">
      <div id="snow" :data-count="snowCount"></div>
      
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
                    <div v-if="apps[1].vpnRequired" class="vpn-tag">VPN</div>
                  </div>
                  <h3 class="app-title">{{ apps[1].name }}</h3>
                  <p class="app-description">{{ apps[1].description }}</p>
                </v-card-text>
              </v-card>
            </div>
            
            <div class="row-divider"></div>
            
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
                    <div v-if="app.vpnRequired" class="vpn-tag">VPN</div>
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
import { ref, onMounted, computed } from 'vue'
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

    // Dynamic snow count based on screen size
    const snowCount = computed(() => {
      if (window.innerWidth <= 480) {
        return 50  // Very small screens
      } else if (window.innerWidth <= 768) {
        return 100 // Small screens
      } else if (window.innerWidth <= 1024) {
        return 150 // Medium screens
      } else {
        return 200 // Large screens
      }
    })

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
      snowCount
    }
  }
}
</script>

<style>
.black-background {
  background-color: #000000;
  background-image: url('/background.png');
  background-size: cover;
  background-position: center;
  background-repeat: no-repeat;
  background-attachment: fixed;
  min-height: 100vh;
  position: relative;
  overflow-x: hidden;
  overflow-y: auto;
}

.black-background::before {
  content: '';
  position: fixed;
  top: 0;
  left: 0;
  right: 0;
  bottom: 0;
  background: 
    radial-gradient(
      ellipse 150% 100% at center,
      transparent 0%,
      rgba(0, 0, 0, 0.6) 20%,
      rgba(0, 0, 0, 0.8) 40%,
      rgba(0, 0, 0, 0.95) 60%,
      rgba(0, 0, 0, 1) 80%
    );
  pointer-events: none;
  z-index: 1;
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



.welcome-container {
  display: flex;
  flex-direction: column;
  align-items: center;
  justify-content: flex-start;
  min-height: 100vh;
  padding: 2rem;
  padding-top: 15vh;
  padding-bottom: 4rem;
  position: relative;
  z-index: 2;
  width: 100%;
  text-align: center;
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
  width: 100%;
  display: block;
}

.cards-container {
  width: 100%;
  max-width: 1200px;
  flex: 1;
  display: flex;
  align-items: flex-end;
  justify-content: center;
  padding-bottom: 4vh;
  margin-bottom: 2rem;
}

.cards-grid {
  width: 100%;
  display: flex;
  flex-direction: column;
  gap: 1rem;
}

.top-row {
  display: flex;
  justify-content: center;
  gap: 2rem;
  margin-bottom: 1rem;
}

.bottom-row {
  display: flex;
  justify-content: center;
  gap: 1rem;
  flex-wrap: wrap;
  margin-top: 1rem;
}

.top-card {
  flex: 0 0 auto;
  width: 250px;
}

.bottom-card {
  flex: 0 0 auto;
  width: 250px;
}

.row-divider {
  width: 100%;
  height: 1px;
  background: linear-gradient(
    90deg,
    transparent 0%,
    rgba(255, 255, 255, 0.1) 20%,
    rgba(255, 255, 255, 0.2) 50%,
    rgba(255, 255, 255, 0.1) 80%,
    transparent 100%
  );
  margin: 1rem 0;
  opacity: 0.6;
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
  text-decoration: underline;
  text-decoration-color: rgba(255, 255, 255, 0.3);
  text-underline-offset: 2px;
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
    font-size: 2rem;
    margin-bottom: 4rem;
    white-space: nowrap;
  }
  
  .welcome-container {
    padding: 1rem;
  }
  
  .top-row {
    flex-direction: row;
    align-items: center;
    gap: 1rem;
    flex-wrap: wrap;
    justify-content: center;
  }
  
  .bottom-row {
    gap: 1rem;
    flex-wrap: wrap;
    justify-content: center;
  }
  
  .top-card,
  .bottom-card {
    width: calc(50% - 0.5rem);
    min-width: 200px;
    max-width: 280px;
  }
}

@media (max-width: 480px) {
  .welcome-title {
    font-size: 1.8rem;
    margin-bottom: 3rem;
    padding-top: 6rem;
    white-space: nowrap;
  }
  
  .top-card,
  .bottom-card {
    width: calc(50% - 0.5rem);
    min-width: 160px;
    max-width: 220px;
  }
  
  .top-row,
  .bottom-row {
    gap: 0.75rem;
  }
}
</style> 