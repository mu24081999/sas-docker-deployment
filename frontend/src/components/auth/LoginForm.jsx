import { useForm } from "react-hook-form";
import { useMutation } from "@tanstack/react-query";
import { login } from "../../api/authApi";
import { Button } from "../common/Button";
import { Input } from "../common/Input";
import toast from "react-hot-toast";
import useAuth from "../../hooks/useAuth";
import { Link, useNavigate } from "react-router-dom";

export const LoginForm = () => {
  const { login: authLogin } = useAuth();
  const navigate = useNavigate();
  const {
    register,
    handleSubmit,
    formState: { errors },
    watch,
  } = useForm({
    defaultValues: { email: "", password: "" },
  });

  // Watch form values for debugging
  const watchedValues = watch();
  console.log("Current form values:", watchedValues);

  const mutation = useMutation({
    mutationFn: login,
    onSuccess: (data) => {
      console.log("Login successful:", data);
      authLogin(data.user, data.token);
      toast.success("Login successful!");
      navigate(`/${data?.user?.role}-dashboard`);
      // navigate(`/dashboard`);
    },
    onError: (error) => {
      console.error("Login error:", error);
      console.error("Error response:", error.response);
      toast.error(error.response?.data?.msg || "Login failed");
    },
  });

  const onSubmit = (data) => {
    console.log("Form submitted with data:", data);
    console.log("API URL:", import.meta.env.VITE_API_URL);
    mutation.mutate(data);
  };

  return (
    <form onSubmit={handleSubmit(onSubmit)} className="space-y-6">
      <Input
        label="Email"
        type="email"
        {...register("email", {
          required: "Email is required",
          pattern: {
            value: /^[^\s@]+@[^\s@]+\.[^\s@]+$/,
            message: "Invalid email address",
          },
        })}
        error={errors.email?.message}
      />
      <Input
        label="Password"
        type="password"
        {...register("password", { required: "Password is required" })}
        error={errors.password?.message}
      />
      <p className="text-slate-600 dark:text-slate-400">
        Not have an account?{" "}
        <Link
          to="/public-register"
          className="text-blue-600 dark:text-blue-400 hover:underline"
        >
          Create one
        </Link>
      </p>
      <p className="text-slate-600 dark:text-slate-400">
        Forgot your password?{" "}
        <Link
          to="/forgot-password"
          className="text-blue-600 dark:text-blue-400 hover:underline"
        >
          Reset Password
        </Link>
      </p>
      <Button type="submit" disabled={mutation.isPending}>
        {mutation.isPending ? "Logging in..." : "Login"}
      </Button>
    </form>
  );
};
