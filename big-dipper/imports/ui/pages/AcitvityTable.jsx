import React, { useEffect, useState } from "react";
import { Spinner } from "reactstrap";
import moment from "moment";
import Pagination from "react-responsive-pagination";

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
              <th>
                Amount
                {/* <ButtonDropdown
            isOpen={this.state.dropdownAmount}
            toggle={this.toggleAmount}
          >
            <DropdownToggle caret>Amount</DropdownToggle>
            <DropdownMenu>
              <Button>{`< $100`}</Button>
              <Button>$100-$1000</Button>
              <Button>$1000-$5000</Button>
              <Button>{`> $5000`}</Button>
            </DropdownMenu>
          </ButtonDropdown> */}
              </th>
              <th>
                Type
                {/* <ButtonDropdown
            isOpen={this.state.dropdownType}
            toggle={this.toggleType}
          >
            <DropdownToggle caret>Type</DropdownToggle>
            <DropdownMenu>
              <Button>Sale</Button>
              <Button>Transfer</Button>
              <Button>Listing</Button>
            </DropdownMenu>
          </ButtonDropdown> */}
              </th>
              <th>From</th>
              <th>To</th>
              <th>
                Time
                {/* <ButtonDropdown
            isOpen={this.state.dropdownTime}
            toggle={this.toggleTime}
          >
            <DropdownToggle caret>Time</DropdownToggle>
            <DropdownMenu>
              <Button>Last 1 day</Button>
              <Button>Last 1 week</Button>
              <Button>Last 1 month</Button>
              <Button>All time</Button>
            </DropdownMenu>
          </ButtonDropdown> */}
              </th>
            </tr>
          </thead>
          <tbody>
            {activityFeedList.map((item, index) => (
              <tr key={index}>
                <td>
                  <div className="user-profile">
                    <img
                      src={item.item_img}
                      height="100"
                      width="100"
                      alt="profile"
                    />
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
