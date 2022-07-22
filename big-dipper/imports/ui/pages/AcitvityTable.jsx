import React, { useEffect, useState } from "react";
import { Spinner } from "reactstrap";
import moment from "moment";
import Pagination from "react-responsive-pagination";

const getMedia = (type, source) => {
  if (type?.toLowerCase() === "image") {
    console.log("source", source);
    return (
      <img
        height="100"
        width="100"
        alt="profile"
        src={source}
        className="mobin-img"
      />
    );
  }
  //no-image.png
  else if (type?.toLowerCase() === "video")
    return (
      <video width="100" height="100" controls>
        <source src={source} type="video/mp4" />
        <source src={source} type="video/ogg" />
        Your browser does not support the video tag.
      </video>
    );
  else if (type?.toLowerCase() === "audio")
    return (
      <audio controls height="100" width="100" alt="profile">
        <source src={source} type="video/mp4" />
        <source src={source} type="video/ogg" />
        Your browser does not support the audio element.
      </audio>
    );
  else if (type?.toLowerCase() === "3d")
    return (
      <model-viewer
        alt="3D NFT"
        src={source}
        ar
        ar-modes="webxr scene-viewer quick-look"
        environment-image="shared-assets/environments/moon_1k.hdr"
        poster="shared-assets/models/NeilArmstrong.webp"
        seamless-poster
        shadow-intensity="1"
        camera-controls
        enable-pan
        height="100"
        width="100"
      ></model-viewer>
    );
  else
    return (
      <img
        height="100"
        width="100"
        alt="profile"
        src="/img/no-image.png"
        className="mobin-img"
      />
    );
};
function AcitvityTable({}) {
  const [activityFeedList, setActivityFeedList] = useState([]);
  const [loadingTableData, setLoadingTableData] = useState(false);
  const [currentPage, setCurrentPage] = useState(1);
  const [totalPages, setTotalPages] = useState(0);
  const limit = 10;
  const getTableData = () => {
    console.log("your page is", currentPage);
    setLoadingTableData(true);
    Meteor.call(
      "Analytics.getAllRecords",
      limit,
      (currentPage - 1) * limit,
      (error, result) => {
        console.log("Analytics.getAllRecords", result);
        if (error) {
          console.log("get Sales Failed: %o", error);
          setTotalPages(0);
          setLoadingTableData(false);
        } else {
          console.log("your data count is", result);
          setActivityFeedList(result.records);
          setTotalPages(Math.ceil(result.count / 10));
          setLoadingTableData(false);
        }
      }
    );
  };
  useEffect(() => {
    getTableData();
  }, [currentPage]);
  if (loadingTableData) return <Spinner type="grow" color="primary" />;
  return (
    <div>
      <div className="table-responsive">
        <table>
          <thead>
            <tr>
              <th>Item</th>
              <th>Amount</th>
              <th>Type</th>
              <th>From</th>
              <th>To</th>
              <th>Time</th>
            </tr>
          </thead>
          <tbody>
            {activityFeedList.map((item, index) => (
              <tr key={index}>
                <td>
                  <div className="user-profile">
                    {getMedia(
                      item.itemFormat,
                      item.itemImg ? item.itemImg : item.item_img
                    )}

                    <a href="#">{item.item_name}</a>
                  </div>
                </td>
                <td>
                  <div className="amount">
                    <>{item.amount}</>
                    <span>{item.extra}</span>
                  </div>
                </td>
                <td>{item.type}</td>
                <td>
                  <a href="#">{item.from}</a>
                </td>
                <td>
                  <a href="#">{item?.to ? item?.to : "-"}</a>
                </td>
                <td>
                  {item?.time
                    ? moment(new Date(item.time).toString()).fromNow()
                    : null}
                </td>
              </tr>
            ))}
          </tbody>
        </table>
      </div>
      <div style={{ marginTop: "20px" }}>
        <Pagination
          current={currentPage}
          total={totalPages}
          onPageChange={setCurrentPage}
        />
      </div>
    </div>
  );
}

export default AcitvityTable;
