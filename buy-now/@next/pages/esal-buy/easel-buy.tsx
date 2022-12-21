import { MetaTags } from "@molecules";
import { Box } from "@mui/material";
import { FC, useEffect, useState } from "react";
import useMediaQuery from "@mui/material/useMediaQuery";
import _ from "lodash";

import { EaselBuyWebView, EaselBuyMobView } from "@organisms";
import { getRecipeHistory } from "@ApiReq";
import { useRouter } from "next/router";

import getConfig from "next/config";
const { publicRuntimeConfig } = getConfig();

export const EaselBuy: FC<any> = (data) => {
  const { settings } = publicRuntimeConfig;

  const matches = useMediaQuery("(min-width:600px)");
  const router: any = useRouter();

  // eslint-disable-next-line @typescript-eslint/naming-convention
  const { cookbook_id, recipe_id } = router?.query;
  const [history, setHistory] = useState<any[]>([]);
  useEffect(() => {
    if (router.isReady) {
      handleFetchhistory();
    }
  }, [router.isReady, cookbook_id, recipe_id]);

  const handleFetchhistory = (): void => {
    void getRecipeHistory(cookbook_id, recipe_id).then((res: any) => {
      setHistory(res?.data?.history);
    });
  };

  const handleLoginConfirmed = (): void => {
    const { apn, ibi, isi, oflIOS, oflPlay, baseURL } =
      settings?.public?.dynamicLink;
    const isMacLike = /(Mac|iPhone|iPod|iPad)/i.test(navigator.platform);
    let ofl = oflPlay;
    if (isMacLike) {
      ofl = oflIOS;
    }
    ofl = encodeURIComponent(ofl);
    const URL = `${baseURL as string}/?amv=1&apn=${apn as string}&ibi=${
      ibi as string
    }&imv=1&efr=1&isi=${isi as string}&`;
    window.location.href = `${URL}ofl=${
      ofl as string
    }&link=${encodeURIComponent(window.location.href)}`;
  };
  return (
    <Box data-testid="easelBuy-page">
      <Box
        sx={{
          backgroundImage: {
            xl: 'url("/images/buybg.png")',
            lg: 'url("/images/buybg.png")',
            md: 'url("/images/buybg.png")',
            sm: 'url("/images/buybg.png")',
            xs: "none",
          },
          backgroundColor: {
            xl: "#000",
            lg: "#000",
            md: "#000",
            sm: "#000",
            xs: "#000",
          },
          backgroundSize: "230px 230px",
          backgroundPosition: "left",
          width: "100%",
          color: "white",
          minHeight: {
            xl: "100vh",
            lg: "100vh",
            md: "100vh",
            sm: "100vh",
            xs: "100%",
          },
          padding: {
            xl: "5rem 0",
            lg: "5rem 0",
            md: "5rem 0",
            sm: "5rem 0",
            xs: "0",
          },
        }}
      >
        {matches ? (
          <EaselBuyWebView
            {...data}
            history={history}
            handleLoginConfirmed={handleLoginConfirmed}
          />
        ) : (
          <EaselBuyMobView
            {...data}
            history={history}
            handleLoginConfirmed={handleLoginConfirmed}
          />
        )}
      </Box>
    </Box>
  );
};
