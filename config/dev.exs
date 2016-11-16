use Mix.Config

config :heroku_bouncex, Bouncer, 
  encryption_salt: "COBuwSQv8yAMvsneF_8OgTsf_M3RFwfvLBNUbv2lD2vUN2E_-d81fYrelqryMejE",
  signing_salt: "CVZ4WUrk__EzDDsBmyPjowuhh07pxGHjQQsy-2cKDHv_kq4Tj-YYNcaOKLrqS2gv",
  secret_key_base: "yxKZ8NnIivFcgscvISCynPz7xZT24UW4PnZOy2Yh3iX8hCPa48N0BVHUbAx-Tgoy"

config :heroku_bouncex, :strategy, Heroku.Bouncex.OAuthStrategy
