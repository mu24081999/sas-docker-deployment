import axios from "axios";

function normalizeBaseUrl(raw) {
  try {
    const trimmed = (raw || "").toString().trim();

    // If empty or clearly bad (e.g., 'https://undefined') → fallback
    if (!trimmed || /^https?:\/\/(undefined|null)\b/.test(trimmed)) {
      return `${window.location.origin}/api/v1`;
    }

    // If starts with '/' → relative to current origin
    if (trimmed.startsWith("/")) {
      return `${window.location.origin}${trimmed}`;
    }

    // If starts with protocol → use as-is
    if (/^https?:\/\//i.test(trimmed)) {
      return trimmed;
    }

    // If looks like host:port or domain/path → default to http
    return `http://${trimmed}`;
  } catch (_) {
    return `${window.location.origin}/api/v1`;
  }
}

const baseURL = normalizeBaseUrl(import.meta.env.VITE_API_URL);

const axiosInstance = axios.create({
  baseURL,
  headers: {
    "Content-Type": "application/json",
  },
});

axiosInstance.interceptors.request.use(
  (config) => {
    const token = localStorage.getItem("token");
    if (token) {
      config.headers.Authorization = `Bearer ${token}`;
    }
    return config;
  },
  (error) => Promise.reject(error)
);

export default axiosInstance;
