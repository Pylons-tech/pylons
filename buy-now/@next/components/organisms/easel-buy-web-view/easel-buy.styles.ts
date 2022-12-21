import styled from 'styled-components'

export const Container = styled.div`
  align-items: center;
  display: flex;
  height: 100%;
  max-width: 1320px;
  margin: 0 auto;
  padding: 0 1rem;
  width: 100%;
  @media (max-width: 599px) {
    display: none;
    padding: 0;
  }

  .tab-panel {
    width: 100%;
    margin: 1rem 0;
    display: flex;
    flex-direction: column;
    width: 100%;
    .item {
      width: 100%;
      align-items: center;
      display: flex;
      justify-content: space-between;
      p {
        color: #fff !important;
        font-size: 1rem;
        font-weight: 400;
        width: 50%;
        a {
          overflow: hidden;
          text-overflow: ellipsis;
          white-space: nowrap;
          display: block;
        }
      }

      &:last-child {
        p {
          margin: 0;
        }
      }
    }
  }
`

export const MediaPart = styled.div`
  padding: 0;
  width: 100%;
  align-items: center;
  display: flex;
  justify-content: center;
  min-height: 45rem;
  max-width: 25rem;
  margin: 0 auto;
  overflow: hidden;
  position: relative;
  .mob-frame {
    position: absolute !important;
    top: 0 !important;
    bottom: 0;
    left: 0;
    right: 0;
    z-index: 1;
  }
  .va-inner {
    align-items: center;
    display: flex;
    justify-content: center;
    max-height: 30rem;
    max-width: 22.5rem;
    position: absolute;
    z-index: 2;
    video {
      height: 30rem;
    }
  }
  .img-inner {
    position: absolute;
  }
  .img-audio {
    align-items: center;
    display: flex;
    flex-direction: column;
    justify-content: center;
    position: absolute;
    audio {
      z-index: 2;
    }
  }
  .mobin-img {
    padding: 0.5rem;
  }

  model-viewer {
    align-items: center;
    display: flex;
    height: 100% !important;
    width: 100% !important;
    position: absolute;
  }

  @media (max-width: 599px) {
    align-items: flex-start;
    background-color: #000;
    min-height: 100vh;
    max-width: 100%;
    padding: 0;
    position: absolute;
    z-index: 0;
    .va-inner {
      align-items: center;
      height: 90vh;
      max-height: 100%;
      max-width: 100%;
      position: static;
      video {
        height: 100%;
      }
    }
    .img-audio {
      height: 90vh;
      max-height: 100%;
      max-width: 100%;
      position: static;
    }
    .img-inner {
      align-items: center;
      height: 90vh;
      max-height: 100%;
      max-width: 100%;
      position: static;
    }
    .media-inner {
      align-items: center;
      display: flex;
      height: 65vh;
    }
    model-viewer {
      align-items: center;
      display: flex;
      height: 500px !important;
      width: 100% !important;
      position: static;
    }
  }
`

export const MobileContainer = styled.div`
  align-items: center;
  display: flex;
  flex-direction: column;
  height: 100%;
  margin: 0 auto;
  padding: 0 0.5rem;
  width: 100%;
  @media (max-width: 599px) {
    position: absolute;
    z-index: 1;
  }

  .tab-panel {
    width: 100%;
    margin: 1rem 0;
    display: flex;
    flex-direction: column;
    width: 100%;
    .item {
      width: 100%;
      align-items: center;
      display: flex;
      justify-content: space-between;
      p {
        color: #fff !important;
        font-size: 1rem;
        font-weight: 400;
        width: 50%;
        a {
          overflow: hidden;
          text-overflow: ellipsis;
          white-space: nowrap;
          display: block;
        }
      }

      &:last-child {
        p {
          margin: 0;
        }
      }
    }
  }

  a {
    font-size: 1.25rem;
  }
  .bg {
    background: rgb(0, 0, 0);
    background: -moz-linear-gradient(
      0deg,
      rgba(0, 0, 0, 1) 0%,
      rgba(0, 0, 0, 0.1516981792717087) 100%
    );
    background: -webkit-linear-gradient(
      0deg,
      rgba(0, 0, 0, 1) 0%,
      rgba(0, 0, 0, 0.1516981792717087) 100%
    );
    background: linear-gradient(
      0deg,
      rgba(0, 0, 0, 1) 0%,
      rgba(0, 0, 0, 0.1516981792717087) 100%
    );
    filter: progid:DXImageTransform.Microsoft.gradient(startColorstr="#000000",endColorstr="#000000",GradientType=1);
  }
  .bg2 {
    background: rgba(0, 0, 0, 0.5);
    backdrop-filter: blur(5px);
    -webkit-backdrop-filter: blur(5px);
  }
  @media (max-width: 320px) {
    .item {
      p {
        width: 45%;
        &:last-child {
          width: 55%;
        }
      }
    }
  }
`
export const BuyBtn = styled.div`
  display: flex;
  justify-content: flex-end;
  align-items: flex-end;
  margin: 5rem 0 0;
  width: 100%;
  .btnbg {
    background: url('/images/btnbg.png') no-repeat;
    background-position: center;
    background-size: cover;
  }
  button {
    align-items: center;
    background-color: transparent;
    border: none;
    color: #fff;
    cursor: pointer;
    display: flex;
    justify-content: space-between;
    position: relative;
    width: 310px;
    height: 75px;
    padding: 0.5rem 2rem;
    .icon {
      width: 2rem;
      border-radius: 10px;
      display: block;
      z-index: 1;
    }
    .value-icon {
      align-items: center;
      display: flex;
      justify-content: space-between;
      width: 90%;
      z-index: 1;
      .values {
        padding: 0 0 0 0.75rem;
        text-align: left;
        p {
          color: #fff;
          font-size: 18px;
          font-weight: 700;
          margin: 0;
        }
        .usd {
          color: #fff;
          font-size: 18px;
          font-weight: 300;
        }
      }
    }
  }
  @media (max-width: 599px) {
    justify-content: flex-start;
    margin: 1rem 0 0;
    button {
      width: 250px;
      height: 60px;
      padding: 0.5rem 1.5rem;
      .value-icon {
        .values {
          p {
            font-size: 16px;
          }
        }
      }
    }
  }
`

export const CollapseBtn = styled.div`
  position: absolute;
  right: -0.5rem;
  top: -1.5rem;
  button {
    height: 1rem;
    width: 1rem;
    min-width: 1rem;
    color: #fff;
    svg {
      font-size: 2.5rem;
    }
  }
  .simple {
    margin: 1rem 1rem 0 0;
  }
  .collapsebg {
    align-items: flex-start;
    display: flex;
    justify-content: flex-end;
    background: url('/images/collapsebg.png') no-repeat;
    background-size: cover;
    background-position: 100% 0;
    height: 4.5rem;
    padding: 0 !important;
    width: 4.5rem;
    svg {
      margin: 0.125rem 0.25rem 0 0;
    }
  }
`
