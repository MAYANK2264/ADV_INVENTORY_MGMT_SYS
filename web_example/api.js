// API service for Google Apps Script backend
class WarehouseAPI {
  constructor(baseUrl) {
    this.baseUrl = baseUrl;
    this.retryAttempts = 3;
    this.retryDelay = 1000; // 1 second
  }

  async request(endpoint, params = {}) {
    const url = new URL(this.baseUrl);
    url.searchParams.set('endpoint', endpoint);
    Object.entries(params).forEach(([key, value]) => {
      if (value !== null && value !== undefined) {
        url.searchParams.set(key, value);
      }
    });

    for (let attempt = 1; attempt <= this.retryAttempts; attempt++) {
      try {
        const response = await fetch(url.toString(), {
          method: 'GET',
          headers: {
            'Accept': 'application/json',
            'Content-Type': 'application/json'
          }
        });

        if (!response.ok) {
          throw new Error(`HTTP ${response.status}: ${response.statusText}`);
        }

        const data = await response.json();
        
        if (data.error) {
          throw new Error(data.error);
        }

        return data;
      } catch (error) {
        console.warn(`Attempt ${attempt} failed:`, error.message);
        
        if (attempt === this.retryAttempts) {
          throw new Error(`Failed after ${this.retryAttempts} attempts: ${error.message}`);
        }
        
        // Wait before retry
        await new Promise(resolve => setTimeout(resolve, this.retryDelay * attempt));
      }
    }
  }

  async getItems() {
    return this.request('items');
  }

  async getStats() {
    return this.request('stats');
  }

  async getActivities() {
    return this.request('activities');
  }

  async getRacks() {
    return this.request('racks');
  }

  async searchItems(query) {
    return this.request('search', { q: query });
  }

  async testConnection() {
    return this.request('test');
  }
}

// Example usage
const API = new WarehouseAPI('https://script.googleusercontent.com/a/macros/iiitsurat.ac.in/echo?user_content_key=AehSKLgL7TBfz-crZPi9jK4mSVGJ6lbk_KJNrd2Ws-F_B9nh2tmIWlUxUvUxa4jN4-MfJ53Mafx-9LWaz45Ufce5CPPWFAFsrdbtmliRie5CXlmVgt8-mHAkqzafYjwVffnCotyZLt4_QFgIKFu9B9oE6XA4VZUhBXpH4su-PvM--oOxKnNTN3v6ph85mCH-C1_YMy4_eQInFvK9zCNFeaJKNBQ23M9E3BEmfqKjnScRBbCLR8UKKnosbEiDaJq7TyohKPX7HlmpnGHznRf9P_gP2izKlSePQSAb9fM4TYWa6gGb7IkA-xTlvzqgkaNHTw&lib=MEfBKtnFjLX4et83hFaVyU0fyXhMohYri');

// Example UI functions
async function loadItems() {
  try {
    const items = await API.getItems();
    console.log('Items loaded:', items);
    return items;
  } catch (error) {
    console.error('Failed to load items:', error.message);
    throw error;
  }
}

async function loadStats() {
  try {
    const stats = await API.getStats();
    console.log('Stats loaded:', stats);
    return stats;
  } catch (error) {
    console.error('Failed to load stats:', error.message);
    throw error;
  }
}
