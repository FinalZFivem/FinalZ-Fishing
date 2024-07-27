const App = Vue.createApp({
    data() {
      return {
        debouncedClick: null,
        fishes: [],
        isProcessing: false
      }
    },
    methods: {
        close() {
            fetch(`https://${GetParentResourceName()}/exit`);
        },
        debounce(func, wait) {
            let timeout;
            return function(...args) {
              const later = () => {
                clearTimeout(timeout);
                func.apply(this, args);
              };
              clearTimeout(timeout);
              timeout = setTimeout(later, wait);
            };
          },
        handleKeyDown(event) {
            if (event.key === "Escape") {
                this.close();
            }
        },
        sell(fish, count) {
            if (this.isProcessing) {
              return;
            }
      
            this.isProcessing = true;
            const actionId = Date.now(); // Create a unique identifier for this action
            this.lastActionId = actionId; // Update the last action id
      
            // Optimistically update the UI
            this.fishes = this.fishes.map(item => {
              if (item.name === fish.name) {
                const newCount = item.count - count;
                return newCount > 0 ? { ...item, count: newCount } : null;
              }
              return item;
            }).filter(item => item !== null);
      
            fetch(`https://${GetParentResourceName()}/sellFish`, {
              method: 'POST',
              headers: {
                'Content-Type': 'application/json',
              },
              body: JSON.stringify({ fish, count }),
            })
            .then(response => response.json())
            .then(data => {
              if (data.success && this.lastActionId === actionId) {
                // Update the UI only if this is the latest action
                this.fishes = data.fishItems
                  .filter(item => item.count > 0)
                  .map(item => ({
                    ...item,
                    img: `img/${item.name}.png`
                  }));
              } else if (!data.success) {
                console.error('Failed to sell fish:', data.message);
              }
              this.isProcessing = false;
            })
            .catch(error => {
              console.error('Error selling fish:', error);
              this.isProcessing = false;
            });
          },
    }, 
    created() {
        this.debouncedClick = this.debounce(this.sell, 250);
      },
    mounted() {
        var _this = this;

        
        window.addEventListener('message', function(event) {
            if (event.data.type == "show") {
                document.body.style.display = event.data.enable ? "block" : "none";
            } else if (event.data.type == "showFishItems") {
                _this.fishes = event.data.items.map(item => ({
                    ...item,
                    img: `img/${item.name}.png`
                }));
            }
        });
        window.addEventListener('keydown', this.handleKeyDown);
    }
    
}).mount('#app')


