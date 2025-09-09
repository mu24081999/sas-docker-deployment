// import PropTypes from "prop-types";

// export const Table = ({ columns, data, actions, rowKey = "_id" }) => {
//   const getRowKey = (item) => {
//     return typeof rowKey === "function" ? rowKey(item) : item[rowKey];
//   };

//   return (
//     <div className="relative border border-slate-200 dark:border-slate-700 rounded-lg overflow-hidden">
//       {/* Main table container with horizontal scrolling */}
//       <div className="overflow-x-auto">
//         <div className="relative">
//           {/* Scrollable table content */}
//           <table
//             className="min-w-full bg-white dark:bg-slate-800 transition-colors"
//             style={{
//               marginRight: actions ? "200px" : "0",
//             }}
//           >
//             <thead>
//               <tr className="bg-slate-50 dark:bg-slate-700">
//                 {columns.map((column) => (
//                   <th
//                     key={column.key}
//                     className="py-2 px-4 border-b border-slate-200 dark:border-slate-600 text-left text-sm font-semibold text-slate-700 dark:text-slate-300 min-w-[200px]"
//                   >
//                     {column.header}
//                   </th>
//                 ))}
//               </tr>
//             </thead>
//             <tbody>
//               {data && data.length > 0 ? (
//                 data.map((item) => (
//                   <tr
//                     key={getRowKey(item)}
//                     className="hover:bg-slate-50 dark:hover:bg-slate-700 transition-colors"
//                   >
//                     {columns.map((column) => (
//                       <td
//                         key={column.key}
//                         className="py-[2.1%] px-4 border-b border-slate-200 dark:border-slate-600 text-sm text-slate-900 dark:text-slate-100"
//                       >
//                         {column.render
//                           ? column.render(item[column.key], item)
//                           : item[column.key] || "-"}
//                       </td>
//                     ))}
//                   </tr>
//                 ))
//               ) : (
//                 <tr>
//                   <td
//                     colSpan={columns.length}
//                     className="py-2 px-4 text-center text-sm text-slate-500 dark:text-slate-400"
//                   >
//                     No data available
//                   </td>
//                 </tr>
//               )}
//             </tbody>
//           </table>

//           {/* Fixed Actions Column */}
//           {actions && (
//             <table className="absolute top-0 right-0 bg-white dark:bg-slate-800 border-l border-slate-200 dark:border-slate-600 shadow-lg">
//               {/* Fixed Actions Header */}
//               <thead>
//                 <tr className="bg-slate-50 dark:bg-slate-700">
//                   <th className="py-[3.9%] px-4 border-b border-slate-200 dark:border-slate-600 text-left text-sm font-semibold text-slate-700 dark:text-slate-300">
//                     Actions
//                   </th>
//                 </tr>
//               </thead>

//               {/* Fixed Actions Content */}
//               <tbody>
//                 {data && data.length > 0 ? (
//                   data.map((item) => (
//                     <tr
//                       key={getRowKey(item)}
//                       className="hover:bg-slate-50 dark:hover:bg-slate-700 transition-colors"
//                     >
//                       <td className="py-[22px] px-4 border-b border-slate-200 dark:border-slate-600 text-sm text-slate-900 dark:text-slate-100">
//                         {actions(item)}
//                       </td>
//                     </tr>
//                   ))
//                 ) : (
//                   <tr>
//                     <td className="py-2 px-4 text-center text-sm text-slate-500 dark:text-slate-400">
//                       {/* Empty state for actions when no data */}
//                     </td>
//                   </tr>
//                 )}
//               </tbody>
//             </table>
//           )}
//         </div>
//       </div>
//     </div>
//   );
// };

// // Table.propTypes = {
// //   columns: PropTypes.arrayOf(
// //     PropTypes.shape({
// //       key: PropTypes.string.isRequired,
// //       header: PropTypes.string.isRequired,
// //       render: PropTypes.func,
// //     })
// //   ).isRequired,
// //   data: PropTypes.arrayOf(PropTypes.object).isRequired,
// //   actions: PropTypes.func,
// //   rowKey: PropTypes.oneOfType([PropTypes.string, PropTypes.func]),
// // };
import PropTypes from "prop-types";

export const Table = ({ columns, data, actions, rowKey = "_id" }) => {
  const getRowKey = (item) => {
    return typeof rowKey === "function" ? rowKey(item) : item[rowKey];
  };

  return (
    <div className="overflow-x-auto">
      <table className="min-w-full bg-white dark:bg-slate-800 border border-slate-200 dark:border-slate-700 transition-colors">
        <thead>
          <tr className="bg-slate-50 dark:bg-slate-700">
            {columns.map((column) => (
              <th
                key={column.key}
                className="py-2 px-4 border-b border-slate-200 dark:border-slate-600 text-left text-sm font-semibold text-slate-700 dark:text-slate-300 min-w-[200px]"
              >
                {column.header}
              </th>
            ))}
            {actions && (
              <th className="py-2 px-4 border-b border-slate-200 dark:border-slate-600 text-left text-sm font-semibold text-slate-700 dark:text-slate-300 min-w-[150px]">
                Actions
              </th>
            )}
          </tr>
        </thead>
        <tbody>
          {data && data.length > 0 ? (
            data.map((item) => (
              <tr
                key={getRowKey(item)}
                className="hover:bg-slate-50 dark:hover:bg-slate-700 transition-colors"
              >
                {columns.map((column) => (
                  <td
                    key={column.key}
                    className="py-2 px-4 border-b border-slate-200 dark:border-slate-600 text-sm text-slate-900 dark:text-slate-100"
                  >
                    {column.render
                      ? column.render(item[column.key], item)
                      : item[column.key] || "-"}
                  </td>
                ))}
                {actions && (
                  <td className="py-2 px-4 border-b border-slate-200 dark:border-slate-600 text-sm text-slate-900 dark:text-slate-100">
                    {actions(item)}
                  </td>
                )}
              </tr>
            ))
          ) : (
            <tr>
              <td
                colSpan={columns.length + (actions ? 1 : 0)}
                className="py-2 px-4 text-center text-sm text-slate-500 dark:text-slate-400"
              >
                No data available
              </td>
            </tr>
          )}
        </tbody>
      </table>
    </div>
  );
};

// Table.propTypes = {
//   columns: PropTypes.arrayOf(
//     PropTypes.shape({
//       key: PropTypes.string.isRequired,
//       header: PropTypes.string.isRequired,
//       render: PropTypes.func,
//     })
//   ).isRequired,
//   data: PropTypes.arrayOf(PropTypes.object).isRequired,
//   actions: PropTypes.func,
//   rowKey: PropTypes.oneOfType([PropTypes.string, PropTypes.func]),
// };
