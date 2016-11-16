use Mix.Config

config :heroku_bouncex, :encryption_salt, "COBuwSQv8yAMvsneF_8OgTsf_M3RFwfvLBNUbv2lD2vUN2E_-d81fYrelqryMejE"
config :heroku_bouncex, :signing_salt, "CVZ4WUrk__EzDDsBmyPjowuhh07pxGHjQQsy-2cKDHv_kq4Tj-YYNcaOKLrqS2gv"
config :heroku_bouncex, :secret_key_base, "yxKZ8NnIivFcgscvISCynPz7xZT24UW4PnZOy2Yh3iX8hCPa48N0BVHUbAx-Tgoy"

config :heroku_bouncex, :strategy, Heroku.Bouncex.TestStrategy
