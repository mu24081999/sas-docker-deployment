import PropTypes from "prop-types";
import { forwardRef } from "react";

export const Textarea = forwardRef(({ label, error, ...props }, ref) => {
  return (
    <div className="space-y-1">
      <label className="block text-sm font-medium text-slate-700 dark:text-slate-300">
        {label}
      </label>
      <textarea
        ref={ref}
        className={`w-full p-2 border rounded-md bg-white dark:bg-slate-800 text-slate-900 dark:text-slate-100 focus:ring-blue-500 dark:focus:ring-blue-400 focus:border-blue-500 dark:focus:border-blue-400 transition-colors ${
          error
            ? "border-red-500 dark:border-red-400"
            : "border-slate-300 dark:border-slate-600"
        }`}
        rows="4"
        {...props}
      />
      {error && (
        <p className="text-sm text-red-500 dark:text-red-400">{error}</p>
      )}
    </div>
  );
});

Textarea.displayName = "Textarea";

Textarea.propTypes = {
  label: PropTypes.string.isRequired,
  error: PropTypes.string,
};
