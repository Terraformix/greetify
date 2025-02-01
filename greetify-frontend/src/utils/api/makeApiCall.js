import axios from 'axios';
import { toast } from 'vue3-toastify';


const makeApiCall = async (method, path, data = null, config = {}) => {

  try {

    const response = await axios({
      method,
      baseURL: import.meta.env.VITE_APP_API_URL ?? undefined,
      url: path,
      data,
      ...config,
    });
    return response.data;
  } catch (error) {
    const errorMessage = error.response?.data?.error || error.message || "An unexpected error occurred";
    console.error('API call error:', errorMessage);
    toast.error(errorMessage);
  }
};

export { makeApiCall };
