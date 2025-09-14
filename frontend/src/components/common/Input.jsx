// export const Input = ({ label, error, className, ...props }) => {
//   return (
//     <div className="mb-4">
//       <label className="block text-sm font-medium text-gray-700">{label}</label>
//       <input
//         className={`mt-1 p-2 w-full border rounded-md focus:ring-blue-500 focus:border-blue-500 ${
//           error ? "border-red-500" : "border-gray-300"
//         } ${className}`}
//         {...props}
//       />
//       {error && <p className="mt-1 text-sm text-red-500">{error}</p>}
//     </div>
//   );
// };

import PropTypes from "prop-types";
import { forwardRef } from "react";

export const Input = forwardRef(
  ({ label, error, className = "", ...props }, ref) => {
    return (
      <div className="mb-4">
        <label className="block text-sm font-medium text-slate-700 dark:text-slate-300">
          {label}
        </label>
        <input
          ref={ref}
          className={`mt-1 p-2 w-full border rounded-md bg-white dark:bg-slate-800 text-slate-900 dark:text-slate-100 focus:ring-blue-500 dark:focus:ring-blue-400 focus:border-blue-500 dark:focus:border-blue-400 transition-colors ${
            error
              ? "border-red-500 dark:border-red-400"
              : "border-slate-300 dark:border-slate-600"
          } ${className}`}
          {...props}
        />
        {error && (
          <p className="mt-1 text-sm text-red-500 dark:text-red-400">{error}</p>
        )}
      </div>
    );
  }
);

Input.displayName = "Input";

Input.propTypes = {
  label: PropTypes.string.isRequired,
  error: PropTypes.string,
  className: PropTypes.string,
};
