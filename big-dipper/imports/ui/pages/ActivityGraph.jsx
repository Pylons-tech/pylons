import React, { useEffect, useState } from "react";
import { Spinner } from "reactstrap";
import {
  Chart as ChartJS,
  CategoryScale,
  LinearScale,
  PointElement,
  LineElement,
  Title,
  Tooltip,
  Legend,
  Filler,
} from "chart.js";
import { Line } from "react-chartjs-2";
import { data } from "jquery";

ChartJS.register(
  CategoryScale,
  LinearScale,
  PointElement,
  Filler,
  LineElement,
  Title,
  Tooltip,
  Legend
);

const options = {
  responsive: true,
  scales: {
    x: {
      grid: {
        display: false,
        drawBorder: false,
      },
    },
    y: {
      ticks: {
        // Include a dollar sign in the ticks
        callback: function (value, index, values) {
          return value;
        },
      },
      grid: {
        display: true,
        borderDash: [8, 4],
        color: "#E4E4E4",
        drawBorder: false,
      },
    },
  },
  plugins: {
    legend: {
      display: false,
      position: "top",
    },
    title: {
      display: false,
    },
  },
};

const labels = [];
const graphInitialData = {
  labels,
  datasets: [
    {
      label: "Total Sales",
      fill: false,
      fillColor: "#0A004A",
      fillOpacity: 0.1,
      data: [],
      borderColor: "#0A004A",
      backgroundColor: "rgba(6, 103, 235,0.1)",
    },
  ],
};

export default ActivityGraph = () => {
  const [graphData, setGraphData] = useState(graphInitialData);
  const [loadingGraph, setLoadingGraph] = useState(false);
  useEffect(() => {
    setLoadingGraph(true);
    Meteor.call("Analytics.getSalesGraph", (error, result) => {
      console.log("Analytics.getSalesGraph", result);
      if (error) {
        console.log("get Sales Failed: %o", error);
        setLoadingGraph(false);
      } else {
        const oldGraphData = { ...graphData };
        oldGraphData.labels = result.map(({ date }, i) => {
          const dateValues = date.split("-");
          return i === result.length - 1
            ? "Today"
            : `${dateValues[1]}/${dateValues[2]}`;
        });
        oldGraphData.datasets[0].data = result.map(({ sales }, i) => {
          return sales;
        });
        console.log("oldGraphData", oldGraphData);
        setGraphData(oldGraphData);
        setLoadingGraph(false);
      }
    });
  }, []);
  return (
    <div className="activity-graph">
      <h4># of Sales</h4>
      {!loadingGraph ? (
        <Line options={options} data={graphData} height="35px" />
      ) : (
        <Spinner type="grow" color="primary" />
      )}
    </div>
  );
};
