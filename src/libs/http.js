import axios from 'axios'
import { message } from 'antd';

// Define the base URL for the API
// const API_BASE_URL = "http://3.84.203.161:8502";
const API_BASE_URL = "https://faucet-devnet.adventurelayer.xyz/";

// Create an axios instance with the base URL
const http = axios.create({
    baseURL: API_BASE_URL
});

// Response interceptor function to handle responses
function handleResponse(response) {
  let result;
  console.log('response', response)
  if (response.status === 200) {
    // Check for error in response
    if (response.error) {
      result = response.error
    // Check if response has data property
    } else if (response.hasOwnProperty('data')) {
      return Promise.resolve(response.data)
    // Check if response is a binary stream
    } else if (response.headers['content-type'] === 'application/octet-stream') {
      return Promise.resolve(response)
    // Check if the request is not internal
    } else if (!response.config.isInternal) {
      return Promise.resolve(response.data)
    } else {
      result = 'Invalid data format'
    }
  } else {
    // Handle non-200 status codes
    result = `Request failed: ${response.status} ${response.statusText}`
  }
  // Display error message
  message.error(result);
  return Promise.reject(result)
}

// Add a response interceptor to the axios instance
http.interceptors.response.use(response => {
  return handleResponse(response)
}, error => {
  if (error.response) {
    // Handle error response
    return handleResponse(error.response)
  }
  // Handle request exceptions
  const result = 'Request exception: ' + error.message;
  message.error(result);
  return Promise.reject(result)
});

// Export the axios instance
export default http;